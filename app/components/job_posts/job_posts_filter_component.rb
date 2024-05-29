module JobPosts
  class JobPostsFilterComponent < ViewComponent::Base
    attr_reader :form_id, :query, :user

    def initialize(query:, user:, form_id: 'job-filter-form')
      @query = query
      @user = user
      @form_id = form_id
      @developer_signed_in = user.developer.present?
    end

    def role_level_selected?(level)
      query.options[:role_level]&.include?(level.to_s)
    end

    def role_type_selected?(type)
      query.options[:role_type]&.include?(type.to_s)
    end

    def location_selected?(location)
      query.options[:role_location]&.include?(location)
    end

    def role_levels
      RoleLevel::TYPES.map { |type| [type.to_s.humanize, type] }
    end

    def role_types
      RoleType::TYPES.map { |type| [type.to_s.humanize, type] }
    end

    def locations
      Businesses::JobPost.role_locations.keys.map { |type| [type, type.humanize] }
    end

    def applied_filter_active?
      params[:filter] == 'applied'
    end

    def all_filter_active?
      params[:filter].blank? || params[:filter] == 'all'
    end
  end
end
