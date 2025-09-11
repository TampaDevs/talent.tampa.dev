class Business < ApplicationRecord
  include Avatarable
  include Businesses::HasOnlineProfiles
  include Businesses::Notifications
  include PersonName
  include Analytics::Profile

  before_save :normalize_phone_number, if: -> { phone_number_present? }

  enum :developer_notifications, %i[no daily weekly], default: :no, suffix: true

  belongs_to :user
  has_one :referring_user, through: :user
  has_many :conversations, -> { visible }

  has_many :job_posts, class_name: "Businesses::JobPost", dependent: :destroy

  has_noticed_notifications

  validates :contact_name, presence: true
  validates :company, presence: true
  validates :bio, presence: true

  validates :phone_number,
    format: {with: /\A(?:\D*\d){10}\D*\z/,
             message: "must be 10 digits"}, presence: true

  validates :developer_notifications, inclusion: {in: developer_notifications.keys}

  alias_attribute :name, :contact_name

  delegate :email, to: :referring_user, prefix: true, allow_nil: true

  def visible?
    !invisible?
  end

  def active_job_posts_count
    job_posts.open.count
  end

  def active_job_posts_limit
    user.permissions.active_job_posts_limit
  end

  def can_create_job_post?
    active_job_posts_count < active_job_posts_limit
  end

  def remaining_job_posts
    [active_job_posts_limit - active_job_posts_count, 0].max
  end

  private

  def phone_number_present?
    phone_number.present?
  end

  def normalize_phone_number
    phone_number.delete!("^0-9")
  end
end
