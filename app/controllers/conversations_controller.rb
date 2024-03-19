class ConversationsController < ApplicationController
  include VisibilityRestrictions
  before_action :authenticate_user!
  before_action :require_developer_and_business_not_invisible!

  def index
    @conversations = current_user.conversations.order(updated_at: :desc)
  end

  def show
    @conversation = conversation
    @message = Message.new(conversation: @conversation)
    authorize @conversation
    Analytics::Event.conversation_shown(current_user, cookies, @conversation)
    @conversation.mark_notifications_as_read(current_user)
  end

  private

  # def require_not_invisible!
  #   if current_user.business.invisible?
  #     store_location!
  #     redirect_to root_path, alert: I18n.t("errors.business_invisible")
  #   elsif current_user.developer.invisible?
  #     store_location!
  #     redirect_to root_path, alert: I18n.t("errors.developer_invisible")
  #   end
  # end
  
  def conversation
    @conversation ||= Conversation.find(params[:id])
  end
end
