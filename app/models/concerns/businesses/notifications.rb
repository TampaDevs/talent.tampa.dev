module Businesses
  module Notifications
    def save_and_notify
      if save
        send_admin_notification
        send_welcome_email if Feature.enabled?(:business_welcome_email)
        true
      end
    end

    def toggle_visibility_and_notify!
      if invisible?
        update!(invisible: false)
      else
        update!(invisible: true)
        send_invisiblize_notification
      end
    end

    private

    def send_welcome_email
      BusinessMailer.with(business: self).welcome.deliver_later
    end

    def send_admin_notification
      Admin::NewBusinessNotification.with(business: self).deliver_later(User.admin)
    end

    def send_invisiblize_notification
      InvisiblizeNotification.with(business: self).deliver_later(user)
    end
  end
end
