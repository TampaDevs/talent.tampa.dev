require "test_helper"

class SwitchLocaleTest < ActionDispatch::IntegrationTest
  test "I18n.locale will depends on the locale of urls" do
    I18n.available_locales.each do |locale|
      I18n.with_locale(locale) do
        get root_path
        assert I18n.locale.to_s == locale.to_s
      end
    end
  end

  test "Visit urls with an unavailable locale will return 404" do
    assert_raises ActionController::RoutingError do
      get root_path(locale: "Klingon")
    end
  end

  def language_name_of(locale)
    I18n.t("shared.footer.language_name_of_locale", locale:)
  end
end
