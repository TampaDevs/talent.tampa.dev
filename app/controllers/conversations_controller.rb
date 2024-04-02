class ConversationsController < ApplicationController
  include VisibilityRestrictions
  before_action :authenticate_user!
  before_action :require_developer_and_business_not_invisible!

  def index
    @conversations = current_user.conversations.visible_to(current_user).order(updated_at: :desc)
  end

  def show
    @conversation = conversation
    @message = Message.new(conversation: @conversation)
    authorize @conversation
    Analytics::Event.conversation_shown(current_user, cookies, @conversation)
    @conversation.mark_notifications_as_read(current_user)
  end

  private

  def conversation
    @conversation ||= Conversation.visible_to(current_user).find(params[:id])
  end
end
