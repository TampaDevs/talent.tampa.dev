require "test_helper"

module Developers
  class QueryComponentTest < ViewComponent::TestCase
    include DevelopersHelper
    include FeatureHelper

    setup do
      @user = users(:empty)
    end

    test "renders top cities for developers" do
      query = DeveloperQuery.new({})
      Location.stub :top_cities, ["New York", "Portland"] do
        render_inline QueryComponent.new(query:, user: @user, form_id: nil)
      end

      assert_selector build_input("cities[]", type: "checkbox", value: "New York")
      assert_selector build_input("cities[]", type: "checkbox", value: "Portland")
    end

    test "renders unique cities for developers" do
      query = DeveloperQuery.new({})
      render_inline QueryComponent.new(query:, user: @user, form_id: nil)

      assert_selector build_input("cities[]", type: "checkbox", value: "Tampa")
      assert_selector "label[for=cities_tampa]", text: "Tampa"
    end

    test "checks selected cities" do
      query = DeveloperQuery.new(cities: ["Tampa"])
      render_inline QueryComponent.new(query:, user: @user, form_id: nil)

      assert_selector build_input("cities[]", type: "checkbox", value: "Tampa", checked: true)
    end

    test "renders unique UTC offset pairs for developers" do
      query = DeveloperQuery.new({})
      render_inline QueryComponent.new(query:, user: @user, form_id: nil)

      assert_selector build_input("utc_offsets[]", type: "checkbox", value: EASTERN_UTC_OFFSET)
      assert_selector build_input("utc_offsets[]", type: "checkbox", value: PACIFIC_UTC_OFFSET)

      assert_selector "label[for=utc_offsets_#{EASTERN_UTC_OFFSET}]", text: "GMT-5"
      assert_selector "label[for=utc_offsets_#{PACIFIC_UTC_OFFSET}]", text: "GMT-8"
    end

    test "checks selected timezones" do
      query = DeveloperQuery.new(utc_offsets: [PACIFIC_UTC_OFFSET])
      render_inline QueryComponent.new(query:, user: @user, form_id: nil)

      assert_no_selector build_input("utc_offsets[]", type: "checkbox", value: EASTERN_UTC_OFFSET, checked: true)
      assert_selector build_input("utc_offsets[]", type: "checkbox", value: PACIFIC_UTC_OFFSET, checked: true)
    end

    test "checks selected role types" do
      query = DeveloperQuery.new(role_types: ["part_time_contract", "full_time_contract"])
      render_inline QueryComponent.new(query:, user: @user, form_id: nil)

      assert_no_selector build_input("role_types[]", type: "checkbox", value: "full_time_employment", checked: true)
      assert_selector build_input("role_types[]", type: "checkbox", value: "part_time_contract", checked: true)
      assert_selector build_input("role_types[]", type: "checkbox", value: "full_time_contract", checked: true)
    end

    test "checks selected role levels" do
      query = DeveloperQuery.new(role_levels: ["junior", "mid", "senior"])
      render_inline QueryComponent.new(query:, user: @user, form_id: nil)

      assert_selector build_input("role_levels[]", type: "checkbox", value: "junior", checked: true)
      assert_selector build_input("role_levels[]", type: "checkbox", value: "mid", checked: true)
      assert_selector build_input("role_levels[]", type: "checkbox", value: "senior", checked: true)
      assert_no_selector build_input("role_levels[]", type: "checkbox", value: "principal", checked: true)
      assert_no_selector build_input("role_levels[]", type: "checkbox", value: "c_level", checked: true)
    end

    test "checks selected badges" do
      stub_feature_flag(:badge_filter, true) do
        query = DeveloperQuery.new(badges: ["recently_added", "source_contributor"])
        render_inline QueryComponent.new(query:, user: @user, form_id: nil)

        assert_selector build_input("badges[]", type: "checkbox", value: "recently_added", checked: true)
        assert_selector build_input("badges[]", type: "checkbox", value: "source_contributor", checked: true)
      end
    end

    test "does not render search query input if user does not have subscription" do
      query = DeveloperQuery.new(search_query: "rails")
      render_inline QueryComponent.new(query:, user: @user, form_id: nil)

      assert_no_selector build_input("search_query", type: "text", value: "rails")
    end

    test "checks value of search query if user has subscription" do
      user = users(:subscribed_business)
      query = DeveloperQuery.new(search_query: "rails")
      render_inline QueryComponent.new(query:, user:, form_id: nil)

      assert_selector build_input("search_query", type: "text", value: "rails")
    end

    test "checks option to include developers who aren't interested" do
      query = DeveloperQuery.new(include_not_interested: true)
      render_inline QueryComponent.new(query:, user: @user, form_id: nil)

      assert_selector build_input("include_not_interested", type: "checkbox", checked: true)
    end

    test "collapse location accordion when location is not being queried" do
      create_developer(location_attributes: {city: "Portland"})

      Location.stub :top_cities, ["New York"] do
        query = DeveloperQuery.new
        render_inline QueryComponent.new(query:, user: @user, form_id: nil)
        assert_selector("#location-accordion.hidden")
        assert_selector("#all-locations-accordion.hidden")

        query = DeveloperQuery.new(cities: ["New York"])
        render_inline QueryComponent.new(query:, user: @user, form_id: nil)
        assert_selector("#location-accordion:not(.hidden)")
        assert_selector("#all-locations-accordion.hidden")

        query = DeveloperQuery.new(cities: ["Portland"])
        render_inline QueryComponent.new(query:, user: @user, form_id: nil)
        assert_selector("#location-accordion:not(.hidden)")
        assert_selector("#all-locations-accordion:not(.hidden)")
      end
    end

    test "collapse timezone accordion when timezone is not being queried" do
      query = DeveloperQuery.new
      render_inline QueryComponent.new(query:, user: @user, form_id: nil)
      assert_selector("#timezone-accordion", visible: false)

      query = DeveloperQuery.new(utc_offsets: [EASTERN_UTC_OFFSET])
      render_inline QueryComponent.new(query:, user: @user, form_id: nil)
      assert_selector("#timezone-accordion", visible: true)
    end

    def build_input(name, type: nil, value: nil, checked: nil)
      input = "input"
      input += "[checked]" if checked
      input += "[type=#{type}]" if type
      input += "[name='#{name}']"
      input += "[value='#{value}']" if value

      input
    end
  end
end
