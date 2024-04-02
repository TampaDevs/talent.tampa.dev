require "test_helper"

class ConversationTest < ActiveSupport::TestCase
  test "messages are sorted oldest first" do
    conversation = conversations(:one)
    assert_equal conversation.messages.pluck(:body), [
      "Earlier message.",
      "One message.",
      "Two message."
    ]
  end

  test "visible does not include ones blocked by the developer" do
    conversation = conversations(:one)
    assert Conversation.visible.include?(conversation)

    conversation.touch(:developer_blocked_at)
    refute Conversation.visible.include?(conversation)
  end

  test "visible does not include ones blocked by the business" do
    conversation = conversations(:one)
    assert Conversation.visible.include?(conversation)

    conversation.touch(:business_blocked_at)
    refute Conversation.visible.include?(conversation)
  end

  test "deleted_business_or_developer returns false if both business and developer" do
    conversation = conversations(:one)

    assert_not conversation.deleted_business_or_developer?
  end

  test "deleted_business_or_developer returns true if developer deleted" do
    conversation = conversations(:one)
    conversation.developer.destroy
    conversation.reload

    assert conversation.deleted_business_or_developer?
  end

  test "deleted_business_or_developer returns true if business deleted" do
    conversation = conversations(:one)
    conversation.business.destroy
    conversation.reload

    assert conversation.deleted_business_or_developer?
  end

  test "other recipient is the business when the user /home/malexander15/tampadevs/talent.tampa.dev/test/models/statsis the developer" do
    user = users(:prospect_developer)
    conversation = conversations(:one)
    assert_equal conversation.other_recipient(user), conversation.business
  end

  test "other recipient is the developer when the user is the business" do
    user = users(:subscribed_business)
    conversation = conversations(:one)
    assert_equal conversation.other_recipient(user), conversation.developer
  end

  test "is blocked if blocked by the developer" do
    conversation = conversations(:one)
    refute conversation.blocked?

    conversation.touch(:developer_blocked_at)
    assert conversation.blocked?
  end

  test "is blocked if blocked by the business" do
    conversation = conversations(:one)
    refute conversation.blocked?

    conversation.touch(:business_blocked_at)
    assert conversation.blocked?
  end

  test "is eligible for the hiring fee when the developer has responded and it is 2+ weeks old" do
    conversation = conversations(:one)
    refute conversation.hiring_fee_eligible?

    conversation.update!(created_at: 2.weeks.ago - 1.day)
    assert conversation.hiring_fee_eligible?

    conversation.messages.from_developer.destroy_all
    refute conversation.hiring_fee_eligible?
  end

  test "latest_message" do
    conversation = conversations(:one)

    assert_equal messages(:from_business), conversation.latest_message
  end

  test "latest_message_read_by_other_recipient? returns false if no messages" do
    conversation = conversations(:one)
    conversation.messages.destroy_all
    user = users(:developer)

    refute conversation.latest_message_read_by_other_recipient?(user)
  end

  test "latest_message_read_by_other_recipient? returns false if latest message has no notification" do
    conversation = conversations(:one)
    conversation.latest_message.notifications_as_message.destroy_all
    user = users(:business)

    refute conversation.latest_message_read_by_other_recipient?(user)
  end

  test "latest_message_read_by_other_recipient? returns false if notification is not read" do
    conversation = conversations(:one)
    user = users(:subscribed_business)
    message = conversation.latest_message
    create_notification(message, user)
    sender = users(:prospect_developer)

    refute conversation.latest_message_read_by_other_recipient?(sender)
  end

  test "latest_message_read_by_other_recipient? returns true if notification is read" do
    conversation = conversations(:one)
    user = users(:subscribed_business)
    message = conversation.latest_message
    notification = create_notification(message, user)
    notification.mark_as_read!
    sender = users(:prospect_developer)

    assert conversation.latest_message_read_by_other_recipient?(sender)
  end

  test "unread_messages_for? returns false if there are no unread notifications for current_user" do
    conversation = conversations(:one)
    user = users(:business)
    conversation.latest_message.notifications_as_message.mark_as_read!

    refute conversation.unread_messages_for? user
  end

  test "unread_messages_for? returns true if there are unread messages for current_user" do
    conversation = conversations(:one)
    user = users(:subscribed_business)
    conversation.messages.create!(sender: conversation.developer, body: "<p>One Message.</p>")

    assert conversation.reload.unread_messages_for?(user)
  end

  test "unread notifications are marked as read" do
    refute notifications(:message_to_business).read?
    refute notifications(:message_to_developer).read?

    user = users(:subscribed_business)
    conversations(:one).mark_notifications_as_read(user)

    assert notifications(:message_to_business).reload.read?
    refute notifications(:message_to_developer).reload.read?
  end

  test "first reply when a developer has sent exactly one message in this conversation" do
    conversation = conversations(:one)
    conversation.messages.destroy_all

    conversation.messages.create!(sender: conversation.business, body: "From business #1")
    refute conversation.first_reply?(conversation.developer)

    conversation.messages.create!(sender: conversation.developer, body: "From developer #1")
    assert conversation.first_reply?(conversation.developer)

    conversation.messages.create!(sender: conversation.business, body: "From business #2")
    refute conversation.first_reply?(conversation.developer)
  end

  test "developer_replied? returns true only when developer has replied" do
    conversation = conversations(:one)
    conversation.messages.destroy_all
    conversation.messages.create!(sender: conversation.business, body: "From business #1")
    refute conversation.developer_replied?

    conversation.messages.create!(sender: conversation.developer, body: "From developer #1")
    assert conversation.developer_replied?
  end

  def create_notification(message, recipient)
    message.notifications_as_message.create!(recipient:,
      type: NewMessageNotification.name,
      params: {message:, conversation: message.conversation})
  end
end
