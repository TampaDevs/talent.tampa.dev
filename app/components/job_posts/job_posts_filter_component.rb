module JobPosts
  class JobPostsFilterComponent < ViewComponent::Base
    attr_reader :form_id, :query, :user

    def initialize(query:, user:, form_id: "job-filter-form")
      @query = query
      @user = user
      @form_id = form_id
      @developer_signed_in = user.developer.present?
      Rails.logger.debug "Initial query parameters inside component: #{@query.options.inspect}"
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

    def reimbursement_min_selected?
      query.options[:reimbursement_min].present?
    end

    def reimbursement_max_selected?
      query.options[:reimbursement_max].present?
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

    def reimbursement_min_value
      query.options[:reimbursement_min]
    end

    def reimbursement_max_value
      query.options[:reimbursement_max]
    end

    def applied_filter_active?
      params[:filter] == "applied"
    end

    def all_filter_active?
      params[:filter].blank? || params[:filter] == "all"
    end
  end
end
