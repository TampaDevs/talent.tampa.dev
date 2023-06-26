module Analytics
  module Profile
    extend ActiveSupport::Concern

    def ap_first_name
      if (is_a?(User) || is_a?(Developer) || is_a?(Business)) && !name.include?("@")
        name&.split&.first
      end
    end

    def ap_last_name
      if (is_a?(User) || is_a?(Developer) || is_a?(Business)) && !name.include?("@")
        name&.split&.last
      end
    end

    def ap_email
      if is_a?(User)
        email
      elsif is_a?(Developer) || is_a?(Business)
        user.email
      end
    end

    def ap_types
      profiles = []
      profiles << :user
      profiles << :developer if is_a?(Developer)
      profiles << :business if is_a?(Business)
      profiles
    end

    def ap_stable_id
      if is_a?(Developer)
        user.id
      elsif is_a?(Business)
        user.id
      elsif is_a?(User)
        id
      end
    end

    def analytics_profile
      profile = {
        ap_first_name: ap_first_name,
        ap_last_name: ap_last_name,
        ap_email: ap_email,
        ap_types: ap_types,
        ap_stable_id: ap_stable_id
      }

      if ap_types.include?(:developer)
        profile[:ap_developer_hashid] = user.developer.hashid
      end

      if ap_types.include?(:business)
        profile[:ap_business_id] = user.business.id
      end

      profile
    end

    def analytics_profile_identify_traits
      trait_map = {ap_first_name: :firstName, ap_last_name: :lastName, ap_email: :email, ap_stable_id: :id, ap_types: :user_types}
      analytics_profile.transform_keys { |key| trait_map[key] }
    end
  end
end
