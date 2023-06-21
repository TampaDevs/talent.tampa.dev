require "test_helper"

class UrlAttributeTest < ActiveSupport::TestCase
  class Model
    include ActiveModel::Attributes
    include UrlAttribute

    attribute :website, :string
    attribute :prefixed_website, :string
    attribute :postprocessed_website, :string

    url_attribute :website
    url_attribute :prefixed_website, prefix: "example.com/"

    url_attribute :postprocessed_website, prefix: "example.com/" do |value|
      "#{value}-postprocessed"
    end
  end

  def setup
    @model = Model.new
  end

  test "works with nil value" do
    @model.website = nil
    assert_nil @model.website

    @model.prefixed_website = nil
    assert_nil @model.prefixed_website

    @model.postprocessed_website = nil
    assert_nil @model.postprocessed_website
  end

  test "works with empty string value" do
    @model.website = ""
    assert_equal "", @model.website

    @model.prefixed_website = ""
    assert_equal "", @model.prefixed_website

    @model.postprocessed_website = ""
    assert_equal "", @model.postprocessed_website
  end

  test "normalizes www website" do
    values = %w[
      www.example.com/tampadevs
      http://www.example.com/tampadevs
      https://www.example.com/tampadevs
    ]

    values.each do |value|
      @model.website = value
      assert_equal "www.example.com/tampadevs", @model.website
    end
  end

  test "normalizes non-www website" do
    values = %w[
      example.com/tampadevs
      http://example.com/tampadevs
      https://example.com/tampadevs
    ]

    values.each do |value|
      @model.website = value
      assert_equal "example.com/tampadevs", @model.website
    end
  end

  test "normalizes website with prefix" do
    values = %w[
      tampadevs
      http://example.com/tampadevs
      https://example.com/tampadevs
      http://www.example.com/tampadevs
      https://www.example.com/tampadevs
    ]

    values.each do |value|
      @model.prefixed_website = value
      assert_equal "tampadevs", @model.prefixed_website
    end
  end

  test "postprocesses website" do
    @model.postprocessed_website = "https://example.com/tampadevs"
    assert_equal "tampadevs-postprocessed", @model.postprocessed_website
  end
end
