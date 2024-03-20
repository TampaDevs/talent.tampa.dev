class DeveloperMailer < ApplicationMailer
  include VisibilityRestrictions

  def welcome
    @developer = params[:developer]
    mail(to: @developer.user.email, subject: t(".subject"))
  end

  def profile_reminder
    @notification = params[:record].to_notification
    recipient = params[:recipient]
    @developer = @notification.developer

    return if user_has_invisible_profiles?(@developer)

    mail(
      to: recipient.email,
      subject: @notification.email_subject,
      from: Rails.configuration.emails.reminders_mailbox!,
      message_stream: :broadcast
    )
  end

  def celebration_promotion
    @conversation = params[:conversation]
    @developer = @conversation.developer
    @business = @conversation.business

    return if user_has_invisible_profiles?(@developer) || user_has_invisible_profiles?(@business)

    mail(
      to: @developer.user.email,
      from: Rails.configuration.emails.reminders_mailbox!,
      subject: t(".subject", contact: @business.contact_name, company: @business.company),
      message_stream: :broadcast
    )
  end

  def first_message
    @developer = params[:developer]

    return if user_has_invisible_profiles?(@developer)

    mail(
      to: @developer.user.email,
      subject: t(".subject")
    )
  end

  def product_announcement
    @notification = params[:record].to_notification
    recipient = params[:recipient]
    @developer = @notification.developer

    mail(
      to: recipient.email,
      subject: @notification.email_subject,
      from: Rails.configuration.emails.updates_mailbox!,
      message_stream: :broadcast
    )
  end
end
