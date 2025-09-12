require "test_helper"

class Developers::JobApplicationTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper
  include NotificationsHelper

  test "sends notification to business when application is created" do
    developer = developers(:one)
    business = businesses(:one)
    
    # Create a job post with required attributes
    job_post = business.job_posts.create!(
      title: "Test Job",
      description: "Test description for a software engineering position",
      city: "Tampa",
      role_location: :remote,
      role_level_attributes: { senior: true },
      role_type_attributes: { full_time_employment: true },
      salary_range_min: 80000,
      salary_range_max: 120000
    )

    assert_sends_notification Businesses::JobApplicationNotification, to: business.user do
      application = job_post.job_applications.create!(developer: developer)
      assert application.persisted?
    end
  end

  test "sends email notification to business when application is created" do
    developer = developers(:one)
    business = businesses(:one)
    
    # Create a job post with required attributes
    job_post = business.job_posts.create!(
      title: "Test Job",
      description: "Test description for a software engineering position",
      city: "Tampa",
      role_location: :remote,
      role_level_attributes: { senior: true },
      role_type_attributes: { full_time_employment: true },
      salary_range_min: 80000,
      salary_range_max: 120000
    )

    assert_enqueued_email_with BusinessMailer, :job_application do
      application = job_post.job_applications.create!(developer: developer)
      assert application.persisted?
    end
  end

  test "invalid application doesn't send notifications" do
    refute_sends_notifications do
      assert_enqueued_emails 0 do
        application = Developers::JobApplication.new
        refute application.save
      end
    end
  end
end
