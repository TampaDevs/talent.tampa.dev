require "test_helper"

class AboutTest < ActionDispatch::IntegrationTest
  test "renders both sections of markdown" do
    get about_path

    assert_select "h3", "Empowering Developers"
    assert_select "li", "Empowering developers and businesses to tap into brilliant local resources."
  end
end
