class JobPostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update apply]
  before_action :require_business!, only: %i[new create edit update]
  before_action :set_job_post, only: [:edit, :update, :show, :apply, :applicants]

  def new
    @job_post = current_user.business.job_posts.new
    build_associations
  end

  def create
    @job_post = current_user.business.job_posts.new(job_post_params)
    build_associations
    set_role_level_and_type
    if @job_post.save
      redirect_to jobs_path, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @job_post
    set_role_level_and_type
    if @job_post.update(job_post_params)
      redirect_to jobs_path, notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
    authorize @job_post
  end

  def index
    Rails.logger.debug "Query parameters: #{permitted_params}"
    @query = JobPostQuery.new(permitted_params)
    Rails.logger.debug "Query options: #{@query.inspect}"
    @job_posts = @query.query
    Rails.logger.debug "Job posts: #{@job_posts.inspect}"
    if current_user.developer.present?
      handle_developer_filters
    end
    @no_job_posts = @job_posts.empty?
    Rails.logger.debug "No job posts: #{@no_job_posts.inspect}"
  end

  def show
  end

  def apply
    unless current_user&.developer.present?
      redirect_to job_path(@job_post), alert: "You must be a developer to apply." and return
    end

    if @job_post.job_applications.where(developer: current_user.developer).exists?
      redirect_to job_path(@job_post), alert: "You have already applied to this job." and return
    else
      application = @job_post.job_applications.create(developer: current_user.developer, status: 'new_status')
      if application.persisted?
        redirect_to job_path(@job_post), notice: "Application submitted successfully."
      else
        redirect_to job_path(@job_post), alert: "Failed to submit the application."
      end
    end
  end

  def applicants
    if current_user.business != @job_post.business
      redirect_to root_path, alert: "You are not authorized to view this page." and return
    end
    @applications = case params[:filter]
                    when 'new_status'
                      @job_post.job_applications.new_status.includes(:developer)
                    when 'considered'
                      @job_post.job_applications.considered.includes(:developer)
                    when 'other'
                      @job_post.job_applications.other.includes(:developer)
                    else
                      @job_post.job_applications.includes(:developer)
                    end
  end

  def update_application_status
    application = Developers::JobApplication.find(params[:application_id])
    if current_user.business == application.job_post.business
      application.update(status: params[:status])
      redirect_back(fallback_location: applicants_job_path(application.job_post), notice: 'Status updated successfully.')
    else
      redirect_back(fallback_location: applicants_job_path(application.job_post), alert: 'You are not authorized to perform this action.')
    end
  end

  private

  def set_job_post
    @job_post = Businesses::JobPost.find(params[:id])
  end

  def build_associations
    @job_post.build_role_level unless @job_post.role_level
    @job_post.build_role_type unless @job_post.role_type
  end

  def set_role_level_and_type
    role_level_choice = params[:job_post][:role_level_choice]
    role_type_choice = params[:job_post][:role_type_choice]

    if role_level_choice.present?
      RoleLevel::TYPES.each { |type| @job_post.role_level.update("#{type}" => false) }
      @job_post.role_level.update("#{role_level_choice}" => true)
    end

    if role_type_choice.present?
      RoleType::TYPES.each { |type| @job_post.role_type.update("#{type}" => false) }
      @job_post.role_type.update("#{role_type_choice}" => true)
    end
  end

  def require_business!
    redirect_to new_business_path, notice: t("errors.business_blank") unless current_user.business.present?
  end

  def job_post_params
    params.require(:job_post).permit(:title, :description, :role_location, :role_level, :role_type, :fixed_fee_min, :fixed_fee_max, :salary_range_min, :salary_range_max, :page)
  end

  def permitted_params
    params.permit(
      :commit,
      :filter,
      :reimbursement_min,
      :reimbursement_max,
      role_type: [],
      role_level: [],
      role_location: []
    ).reject { |_, v| v.blank? }
  end

  def handle_developer_filters
    if params[:filter].blank?
      query_params = permitted_params.merge(filter: :all)
      Rails.logger.debug "Query params: #{query_params}"
      @query.options.merge!(query_params)
      redirect_to jobs_path(@query.options) and return
    elsif params[:filter] == 'applied'
      @job_posts = @job_posts.joins(:job_applications).where(job_applications: { developer_id: current_user.developer.id })
    elsif params[:filter] == 'all'
      @job_posts = @job_posts.where.not(id: Developers::JobApplication.where(developer_id: current_user.developer.id).pluck(:job_post_id))
    end
  end
end
