class JobPostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update]
  before_action :require_business!, only: %i[new create edit update]
  before_action :set_job_post, only: [:edit, :update, :show]

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
    @job_post = Businesses::JobPost.all # Use @job_posts for the collection
  end

  def show
    # @job_post is set by before_action
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
    params.require(:businesses_job_post).permit(
      :title, :salary_range_min, :salary_range_max, :description, :status, :role_location, :city, :fixed_fee
    )
  end
end
