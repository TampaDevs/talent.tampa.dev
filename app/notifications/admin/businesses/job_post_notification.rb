module Admin
  module Businesses
    class JobPostNotification < ApplicationNotification
      deliver_by :database
      deliver_by :email, mailer: "AdminMailer", method: :businesses_job_post

      param :job_post

      def title
        t("notifications.admin.businesses.job_post_notification.title", business: job_post.business.name)
      end

      def url
        admin_businesses_job_post_path(job_post)
      end

      def job_post
        params[:job_post]
      end
    end
  end
end
