module Businesses
  class JobPost < ApplicationRecord
    self.table_name = "job_posts"
    include ::Businesses::JobPosts::Notifications

    belongs_to :business
    has_many :job_applications, dependent: :destroy
    has_one :role_level, dependent: :destroy, autosave: true
    has_one :role_type, dependent: :destroy, autosave: true

    enum status: { open: 1, closed: 2 }
    enum role_location: { remote: 1, in_office: 2, hybrid: 3 }

    validates :role_level, :role_type, :role_location, :description, :city, presence: true
    validates :description, length: { minimum: 10 }
    validates :city, length: { minimum: 2 }

    validate :validate_salary_range_for_full_time_employment
    validate :validate_fixed_fee_for_contract

    scope :open, -> { where(status: :open) }

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
