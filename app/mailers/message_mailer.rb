class MessageMailer < ApplicationMailer
  include VisibilityRestrictions

  default from: Rails.configuration.emails.notifications_mailbox!

  def new_message
    @notification = params[:record].to_notification
    @recipient = params[:recipient]

    @message = @notification.message
    @sender = @message.sender.name

    conversation_token = @message.conversation.inbound_email_token

    return if user_has_invisible_profiles?(@recipient) || user_has_invisible_profiles?(@sender)

    mail(
      to: @recipient.email,
      subject: @notification.email_subject,
      reply_to: "#{@sender} <conversation+#{conversation_token}@inbound.talent.tampa.dev>"
    )
  end
end
