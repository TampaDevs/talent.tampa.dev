module Businesses
  class JobPost < ApplicationRecord
    self.table_name = "job_posts"
    include ::Businesses::JobPosts::Notifications

    include PgSearch::Model
    pg_search_scope :filter_by_search_query, against: [:title, :description], using: {tsearch: {tsvector_column: :textsearchable_index_col, prefix: true}}

    belongs_to :business
    has_many :job_applications, dependent: :destroy, class_name: "Developers::JobApplication"
    has_one :role_level, dependent: :destroy, autosave: true
    has_one :role_type, dependent: :destroy, autosave: true

    validates :title, presence: true

    enum status: {open: 1, closed: 2}
    enum role_location: {remote: 1, in_office: 2, hybrid: 3}

    validates :role_level, :role_type, :role_location, :description, :city, presence: true
    validates :description, length: {minimum: 10}
    validates :city, length: {minimum: 2}

    validate :validate_salary_range_for_full_time_employment
    validate :validate_fixed_fee_for_contract

    accepts_nested_attributes_for :role_level
    accepts_nested_attributes_for :role_type

    scope :open, -> { where(status: :open) }
    scope :newest_first, -> { order(created_at: :desc) }
    scope :with_role_level, ->(levels) {
      joins(:role_level).where("role_levels.level = ANY (ARRAY[?]::text[])", levels) if levels.present?
    }


    scope :with_role_type, ->(type) {
      joins(:role_type).where(role_types: { type.to_sym => true }) if 
      RoleType::TYPES.include?(type.to_sym)
    }
    scope :with_role_locations, ->(locations) {
      where(role_location: locations)
    }

def self.valid_role_locations?(locations)
  locations.all? { |location| role_locations.keys.include?(location) }
end


    def contract_role?
      role_type&.part_time_contract? || role_type&.full_time_contract?
    end

    def self.with_role_type(type)
      case type
      when 'part_time_contract'
        joins(:role_type).where(role_types: { part_time_contract: true })
      when 'full_time_contract'
        joins(:role_type).where(role_types: { full_time_contract: true })
      when 'full_time_employment'
        joins(:role_type).where(role_types: { full_time_employment: true })
      else
        # Handle the case where type is not recognized
        all
      end
    end

    private

    def validate_salary_range_for_full_time_employment
      if role_type&.full_time_employment?
        errors.add(:salary_range_min, "must be less than or equal to salary_range_max and greater than 0") unless salary_range_min.present? && salary_range_min > 0 && salary_range_min <= salary_range_max
        errors.add(:salary_range_max, "must be greater than 0") unless salary_range_max.present? && salary_range_max > 0
      end
    end

    def validate_fixed_fee_for_contract
      if role_type&.part_time_contract? || role_type&.full_time_contract?
        errors.add(:fixed_fee, "must be greater than 0") unless fixed_fee.present? && fixed_fee > 0
      end
    end
  end
end