module Businesses
  class JobApplicationNotification < ApplicationNotification
    deliver_by :database

    param :job_application_id

    def title
      t("notifications.businesses.job_application_notification.title", 
        developer: job_application.developer.name,
        job_post: job_application.job_post.title)
    end

    def email_subject
      t("notifications.businesses.job_application_notification.email_subject",
        developer: job_application.developer.name,
        job_post: job_application.job_post.title)
    end

    def url
      job_post_applicants_url(job_application.job_post)
    end

    def job_application
      @job_application ||= Developers::JobApplication.find(params[:job_application_id])
    end

    # Custom delivery method to avoid the to_sym issue
    after_database :send_email_notification

    private

    def send_email_notification
      BusinessMailer.with(
        job_application: job_application,
        recipient: job_application.job_post.business.user
      ).job_application.deliver_later
    end
  end
end
