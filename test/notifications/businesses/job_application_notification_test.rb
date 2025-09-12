require "test_helper"

module Businesses
  class JobApplicationNotificationTest < ActiveSupport::TestCase
    test "delivers notification via database and email" do
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

      application = job_post.job_applications.create!(developer: developer)
      notification = Businesses::JobApplicationNotification.with(job_application: application)

      assert_equal application, notification.job_application
      assert_equal job_post, notification.job_application.job_post
      assert_equal business, notification.job_application.job_post.business
      assert_equal developer, notification.job_application.developer
    end

    test "generates correct title and email subject" do
      developer = developers(:one)
      business = businesses(:one)
      
      # Create a job post with required attributes
      job_post = business.job_posts.create!(
        title: "Software Engineer Position",
        description: "Test description for a software engineering position",
        city: "Tampa",
        role_location: :remote,
        role_level_attributes: { senior: true },
        role_type_attributes: { full_time_employment: true },
        salary_range_min: 80000,
        salary_range_max: 120000
      )

      application = job_post.job_applications.create!(developer: developer)
      notification = Businesses::JobApplicationNotification.with(job_application: application)

      expected_title = "#{developer.name} applied to your job: #{job_post.title}"
      assert_equal expected_title, notification.title
      assert_equal expected_title, notification.email_subject
    end

    test "generates correct URL" do
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

      application = job_post.job_applications.create!(developer: developer)
      notification = Businesses::JobApplicationNotification.with(job_application: application)

      expected_url = Rails.application.routes.url_helpers.job_post_applicants_url(job_post)
      assert_equal expected_url, notification.url
    end
  end
end
