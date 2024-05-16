module Messages
  module Notifications
    include VisibilityRestrictions

    def save_and_notify(cold_message: false)
      return false if user_has_invisible_profiles?(sender)

      if save
        send_recipient_notification unless user_has_invisible_profiles?(recipient)

        send_first_message_email if first_message? && !user_has_invisible_profiles?(conversation.developer)
        schedule_celebration_promotion if first_reply? && !user_has_invisible_profiles?(conversation.developer)

        send_admin_notification if cold_message
        update_developer_response_rate if cold_message
        true
      else
        false
      end
    end

    private

    def send_recipient_notification
      NewMessageNotification.with(message: self, conversation:).deliver_later(recipient.user)
    end

    def send_admin_notification
      Admin::NewConversationNotification.with(conversation:).deliver_later(User.admin)
    end

    def send_first_message_email
      DeveloperMailer.with(developer: conversation.developer).first_message.deliver_later
    end

    def schedule_celebration_promotion
      wait = Rails.configuration.deliver_celebration_promotion_after
      DeveloperMailer.with(conversation: conversation).celebration_promotion.deliver_later(wait:)
    end

    def update_developer_response_rate
      wait = Rails.application.config.developer_response_grace_period
      UpdateDeveloperResponseRateJob.set(wait:).perform_later(developer.id)
    end

    def first_message?
      Message.first_message?(conversation.developer)
    end

    def first_reply?
      conversation.first_reply?(conversation.developer)
    end
  end
end
