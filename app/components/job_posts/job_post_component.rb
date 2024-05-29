# app/components/jobpost/job_post_component.rb
class JobPosts::JobPostComponent < ViewComponent::Base
  def initialize(job_post:, current_user:, user_signed_in:)
    @job_post = job_post
    @current_user = current_user
    @user_signed_in = user_signed_in
  end

  def formatted_reimbursement
    if @job_post.fixed_fee.present?
      number_to_currency(@job_post.fixed_fee)
    else
      "#{number_to_currency(@job_post.salary_range_min)} - #{number_to_currency(@job_post.salary_range_max)}"
    end
  end
end
