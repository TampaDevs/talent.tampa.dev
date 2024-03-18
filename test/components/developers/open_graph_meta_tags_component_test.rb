require "test_helper"

module Developers
  class OpenGraphTagsComponentTest < ViewComponent::TestCase
    include TurboNativeHelper

    test "always includes basic tags" do
      developer = developers(:one)

      render_inline OpenGraphTagsComponent.new(developer:)

      assert_meta property: "og:title", content: "#{developer.hero} · Tampa Devs Talent"
      assert_meta property: "og:description", content: developer.bio
      assert_meta property: "og:url", content: "http://test.host/developers/#{developer.hashid}"
    end

    test "excludes special tags when not present" do
      developer = Developer.new(id: 123)

      render_inline OpenGraphTagsComponent.new(developer:)

      assert_meta property: "og:image", count: 0
    end

    test "includes image when present" do
      developer = Developer.new(id: 123)
      developer.build_avatar_blob(filename: "avatar.jpg")

      render_inline OpenGraphTagsComponent.new(developer:)

      assert_meta property: "og:image", content_end_with: "/avatar.jpg"
    end

    test "Turbo Native requests" do
      turbo_native_request!
      developer = Developer.new(id: 123, twitter: "me")
      render_inline Developers::OpenGraphTagsComponent.new(developer:)
      title = I18n.t("developers.open_graph_tags_component.turbo_native_title")
      assert_selector "title", exact_text: title, visible: false
    end
  end
end
