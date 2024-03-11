module Developers
  class JobApplication < ApplicationRecord
    belongs_to :job_post
    belongs_to :developer

    enum status: {
      unread: 0,
      accepted: 1,
      ignored: 2
    }

    # Validations
    validates :job_post, :developer, presence: true

    # TODO: Notify Business when a developer applies to their job post

    # after_create :send_application_received_notification
    # def send_application_received_notification
    #   # Notification logic here
    # end

    # Scopes
    scope :for_job_post, ->(job_post_id) { where(job_post_id: job_post_id) }
    scope :from_developer, ->(developer_id) { where(developer_id: developer_id) }
  end
end
