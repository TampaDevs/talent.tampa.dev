# app/components/job_posts/job_posts_filter_component.rb
module JobPosts
  class JobPostsFilterComponent < ViewComponent::Base
    attr_reader :form_id, :job_post_query, :user

    def initialize(job_post_query:, user:, form_id: 'job-filter-form')
      @job_post_query = job_post_query
      @user = user
      @form_id = form_id
    end

    def role_levels
      RoleLevel::TYPES.filter_map { |type|
      type if RoleLevel.where(type => true).exists?
      }.map { |type| [type, type.to_s.humanize] }
    end

    def role_types
      RoleType::TYPES.filter_map { |type|
      type if RoleType.where(type => true).exists?
      }.map { |type| [type.to_s.humanize, type] }
    end

    def reimbursement_types
      ['fixed_fee', 'salary_range']
    end

    def locations
      Businesses::JobPost.role_locations.keys.map { |type| [type, type.humanize] }
    end
  end
end
