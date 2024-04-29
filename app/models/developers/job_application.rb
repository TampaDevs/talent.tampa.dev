module Developers
  class JobApplication < ApplicationRecord
    self.table_name = "job_applications"
    belongs_to :job_post, class_name: "Businesses::JobPost"
    belongs_to :developer

    enum status: {
      new_status: 0, #new
      considered: 1, #considered
      other: 2 #other
    }

    def human_status
      {
        'new_status' => 'New',
        'considered' => 'Considered',
        'other' => 'Other'
      }[status]
    end

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
