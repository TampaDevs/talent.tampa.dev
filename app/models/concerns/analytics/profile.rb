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
        self.try(:user).try(:email)
      end
    end    

    def ap_types
      profiles = []
      profiles << :user
      profiles << :developer if self.try(:developer).present?
      profiles << :business if self.try(:business).present?
      profiles
    end    

    def ap_stable_id
      if is_a?(User)
        id
      elsif is_a?(Developer) || is_a?(Business)
        self.try(:user).try(:id)
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
    
      if is_a?(User)
        if ap_types.include?(:developer)
          profile[:ap_developer_hashid] = self.try(:developer).try(:hashid)
        end
    
        if ap_types.include?(:business)
          profile[:ap_business_id] = self.try(:business).try(:id)
        end
      elsif is_a?(Developer)
        profile[:ap_developer_hashid] = self.try(:hashid)
      elsif is_a?(Business)
        profile[:ap_business_id] = self.try(:id)
      end
    
      profile
    end    

    def analytics_profile_identify_traits
      trait_map = {ap_first_name: :firstName, ap_last_name: :lastName, ap_email: :email, ap_stable_id: :id, ap_types: :user_types}
      analytics_profile.transform_keys { |key| trait_map[key] }
    end
  end
end
