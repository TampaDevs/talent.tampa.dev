require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "deleted_sender is true if business is nil" do
    message = messages(:from_business)
    sender = message.sender
    sender.destroy
    message.reload

    assert message.deleted_sender?
  end

  test "deleted_sender is true if developer is nil" do
    message = messages(:from_developer)
    sender = message.sender
    sender.destroy
    message.reload

    assert message.deleted_sender?
  end

  test "deleted_sender is false if sender is present" do
    message = messages(:from_developer)

    assert_not message.deleted_sender?
  end

  test "user is sender if they are the associated developer" do
    user = users(:prospect_developer)
    assert messages(:from_developer).sender?(user)
    refute messages(:from_business).sender?(user)
  end

  test "user is sender if they are the associated business" do
    user = users(:subscribed_business)
    assert messages(:from_business).sender?(user)
    refute messages(:from_developer).sender?(user)
  end

  test "user is not the sender if they are neither the associated developer nor business" do
    user = users(:empty)
    refute messages(:from_developer).sender?(user)
  end

  test "body_html is filled with rendered html version of body" do
    message = Message.new(body: "Check out https://talent.tampa.dev/!")

    assert_equal '<p>Check out <a href="https://talent.tampa.dev/" target="_blank">https://talent.tampa.dev/</a>!</p>', message.body_html
  end

  test "user (developer) has their first message" do
    developer = users(:developer).developer
    business = users(:subscribed_business).business
    conversation = Conversation.find_or_initialize_by(business:, developer:)
    Message.create(body: "Hello", sender: business, conversation:)

    assert Message.first_message?(developer)
  end

  test "user (developer) doesn't have any message" do
    user = users(:developer)
    refute Message.first_message?(user.developer)
  end

  test "user (developer) has many messages" do
    user = users(:prospect_developer)
    refute Message.first_message?(user.developer)
  end

  test "latest_notification_for_recipient returns nil if no notification" do
    message = messages(:from_business)
    recipient = users(:subscribed_business)

    assert_not message.latest_notification_for_recipient(recipient)
  end

  test "latest_notification_for_recipient returns a notification" do
    message = messages(:from_developer)
    notification = notifications(:message_to_business)
    recipient = users(:subscribed_business)

    assert_equal notification, message.latest_notification_for_recipient(recipient)
  end
end
