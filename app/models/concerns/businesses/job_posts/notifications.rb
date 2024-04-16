module Businesses
  module JobPosts
    module Notifications
      extend ActiveSupport::Concern

      included do
        # any setup you need to do when this module is included
      end

      def save_and_notify
        if save
          send_admin_notification
          true
        else
          false
        end
      end

      def send_admin_notification
        Admin::Businesses::JobPostMailer.with(job_post: self).deliver_later(User.admin)
      end
    end
  end
end
