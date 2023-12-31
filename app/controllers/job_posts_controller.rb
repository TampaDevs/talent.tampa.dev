
class JobPostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update]
  before_action :require_business!, only: %i[new create edit update]

  def new
    @form = Businesses::JobPost.new(business: current_user.business)
  end

  def create
    @form = Businesses::JobPost.new(form_params)
    if @form.save_and_notify
      Analytics::Event.job_post_created(current_user, cookies, @form)
      redirect_to root_path, notice: t(".success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def business
    @business = current_user.business
  end

  def require_business!
    unless business.present?
      store_location!
      redirect_to new_business_path, notice: I18n.t("errors.business_blank")
    end
  end

  def form_params
    params.require(:businesses_job_post).permit(
      :annual_salary,
      :position,
      :start_date,
      :employment_type,
      :description
    ).merge(business: business)
  end
end
  