class JobPost < ApplicationRecord
  self.table_name = "job_posts"
  include JobPosts::Notifications

  belongs_to :business
  has_many :job_applications, dependent: :destroy

  enum status: {
    open: 1,
    closed: 2
  }

  enum employment_type: {
    freelance_or_contract: 1,
    full_time_employment: 2
  }

  enum role_type: {
    remote: 1,
    in_office: 2,
    hybrid: 3
  }

  has_one :role_level

  # Validation for salary ranges in case of full-time employment
  validates :salary_range_min, numericality: { less_than_or_equal_to: :salary_range_max, greater_than: 0, only_integer: true }, if: :full_time_employment?, allow_nil: true
  validates :salary_range_max, numericality: { greater_than: 0, only_integer: true }, if: :full_time_employment?, allow_nil: true
  
  # Validation for fixed fee in case of freelance or contract work
  validates :fixed_fee, numericality: { greater_than: 0, only_integer: true }, if: :freelance_or_contract?, allow_nil: true
  
  # General validations
  validates :employment_type, :description, :location, :role_level, presence: true
  validates :description, length: { minimum: 10 }
  validates :location, length: { minimum: 2 }

  # Scopes
  scope :open, -> { where(status: :open) }
  scope :full_time, -> { where(employment_type: :full_time_employment) }
  scope :contract, -> { where(employment_type: :freelance_or_contract) }
end
