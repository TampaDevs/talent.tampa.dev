require "test_helper"

class Developers::HasOnlineProfilesTest < ActiveSupport::TestCase
  def setup
    @model = Developer.new
  end

  test "normalizes website" do
    values = %w[
      http://www.example.com/tampadevs
      https://www.example.com/tampadevs
    ]

    values.each do |value|
      @model.website = value
      assert_equal "www.example.com/tampadevs", @model.website
    end
  end

  test "normalizes Mastodon" do
    values = %w[
      http://server.name/@tampadevs
      https://server.name/@tampadevs
    ]

    values.each do |value|
      @model.mastodon = value
      assert_equal "server.name/@tampadevs", @model.mastodon
    end
  end

  test "normalizes scheduling_link" do
    values = %w[
      http://savvycal.com/tampadevs/chat
      https://savvycal.com/tampadevs/chat
    ]

    values.each do |value|
      @model.scheduling_link = value
      assert_equal "savvycal.com/tampadevs/chat", @model.scheduling_link
    end
  end

  test "normalizes GitHub handle" do
    values = %w[
      tampadevs
      http://github.com/tampadevs
      https://github.com/tampadevs
      http://www.github.com/tampadevs
      https://www.github.com/tampadevs
    ]

    values.each do |value|
      @model.github = value
      assert_equal "tampadevs", @model.github
    end
  end

  test "normalizes Twitter handle" do
    values = %w[
      tampadevs
      http://twitter.com/tampadevs
      https://twitter.com/tampadevs
      http://www.twitter.com/tampadevs
      https://www.twitter.com/tampadevs
    ]

    values.each do |value|
      @model.twitter = value
      assert_equal "tampadevs", @model.twitter
    end
  end

  test "normalizes LinkedIn handle" do
    values = %w[
      tampadevs
      http://linkedin.com/in/tampadevs
      https://linkedin.com/in/tampadevs
      http://www.linkedin.com/in/tampadevs
      https://www.linkedin.com/in/tampadevs
    ]

    values.each do |value|
      @model.linkedin = value
      assert_equal "tampadevs", @model.linkedin
    end
  end

  test "normalizes Stack Overflow handle" do
    values = %w[
      123456
      http://stackoverflow.com/users/123456/tampadevs
      https://stackoverflow.com/users/123456/tampadevs
      http://stackoverflow.com/users/123456
      https://stackoverflow.com/users/123456
      http://www.stackoverflow.com/users/123456/tampadevs
      https://www.stackoverflow.com/users/123456/tampadevs
      http://www.stackoverflow.com/users/123456
      https://www.stackoverflow.com/users/123456
    ]

    values.each do |value|
      @model.stack_overflow = value
      assert_equal "123456", @model.stack_overflow
    end
  end
end
