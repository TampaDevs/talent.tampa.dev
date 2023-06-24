module Analytics
  class Event < ApplicationRecord
    self.table_name = "analytics_events"

    validates :url, presence: true
    validates :goal, presence: true
    validates :value, presence: true, numericality: {greater_than_or_equal_to: 0}

    def self.added_developer_profile(url, cookies, developer)
      SegmentClient.track(
        user_id: developer.hashid,
        event: "developer_profile_added",
        properties: developer.attributes
      )
      Analytics::Event.create!(url:, goal: goals.added_developer_profile)
    end

    def self.added_business_profile(url, cookies, business)
      SegmentClient.track(
        user_id: business.hashid,
        event: "business_profile_added",
        properties: business.attributes
      )
      Analytics::Event.create!(url:, goal: goals.added_business_profile)
    end

    def self.subscribed_to_busines_plan(url, user, value:)
      SegmentClient.track(
        user_id: user.hashid,
        event: "business_plan_checkout_started",
        properties: {value: value, user_id: user.id, user_email: user.email, path: url}
      )
      Analytics::Event.create!(url:, goal: goals.subscribed_to_busines_plan, value: value * 100)
    end

    def self.subscription_created(customer)
      SegmentClient.track(
        event: "business_plan_subscribe_success",
        properties: customer.attributes
      )
    end

    def self.subscription_canceled(customer)
      SegmentClient.track(
        event: "business_plan_subscribe_cancel",
        properties: customer.attributes
      )
    end

    def self.celebration_package_requested(developer, cookies, form)
      SegmentClient.track(
        user_id: developer.hashid,
        anonymous_id: cookies[:uuid],
        event: "celebration_package_requested",
        properties: {form: form.attributes}
      )
    end

    def self.developers_search_queried(user, cookies, query, num_results)
      if user.nil?
        SegmentClient.track(
          anonymous_id: cookies[:uuid],
          event: "developer_search_queried",
          properties: {query: query, num_results: num_results}
        )
      else
        SegmentClient.track(
          user_id: user.hashid,
          anonymous_id: cookies[:uuid],
          event: "developer_search_queried",
          properties: {query: query, num_results: num_results}
        )
      end
    end

    def self.developers_profile_shown(user, cookies, id)
      if user.nil?
        SegmentClient.track(
          anonymous_id: cookies[:uuid],
          event: "developers_profile_shown",
          properties: {id: id}
        )
      else
        SegmentClient.track(
          user_id: user.hashid,
          anonymous_id: cookies[:uuid],
          event: "developers_profile_shown",
          properties: {id: id}
        )
      end
    end

    def self.developers_page_viewed(user, cookies)
      if user.nil?
        SegmentClient.track(
          anonymous_id: cookies[:uuid],
          event: "developers_page_viewed"
        )
      else
        SegmentClient.track(
          user_id: user.hashid,
          anonymous_id: cookies[:uuid],
          event: "developers_page_viewed"
        )
      end
    end

    def self.developer_profile_updated(user, cookies, params)
      SegmentClient.track(
        user_id: user.hashid,
        anonymous_id: cookies[:uuid],
        event: "developer_profile_updated",
        properties: params.to_h
      )
    end

    def self.business_profile_updated(user, cookies, business)
      SegmentClient.track(
        user_id: user.hashid,
        anonymous_id: cookies[:uuid],
        event: "business_profile_updated",
        properties: business.attributes
      )
    end

    def self.hiring_agreement_signature_created(user, cookies, signature)
      SegmentClient.track(
        user_id: user.hashid,
        anonymous_id: cookies[:uuid],
        event: "hiring_agreement_signature_created",
        properties: signature.attributes
      )
    end

    def self.cold_message_created(user, cookies, message)
      SegmentClient.track(
        user_id: user.hashid,
        anonymous_id: cookies[:uuid],
        event: "cold_message_created",
        properties: message.attributes
      )
    end

    def self.block_created(user, cookies, conversation, other_recipient)
      SegmentClient.track(
        user_id: user.hashid,
        anonymous_id: cookies[:uuid],
        event: "block_created",
        properties: {conversation: conversation.attributes, other_recipient: other_recipient}
      )
    end

    def self.about_page_viewed(user, cookies)
      if user.nil?
        SegmentClient.track(
          anonymous_id: cookies[:uuid],
          event: "about_page_viewed"
        )
      else
        SegmentClient.track(
          user_id: user.hashid,
          anonymous_id: cookies[:uuid],
          event: "about_page_viewed"
        )
      end
    end

    def self.tos_page_viewed(user, cookies)
      if user.nil?
        SegmentClient.track(
          anonymous_id: cookies[:uuid],
          event: "tos_page_viewed"
        )
      else
        SegmentClient.track(
          user_id: user.hashid,
          anonymous_id: cookies[:uuid],
          event: "tos_page_viewed"
        )
      end
    end

    def self.privacy_page_viewed(user, cookies)
      if user.nil?
        SegmentClient.track(
          anonymous_id: cookies[:uuid],
          event: "privacy_page_viewed"
        )
      else
        SegmentClient.track(
          user_id: user.hashid,
          anonymous_id: cookies[:uuid],
          event: "privacy_page_viewed"
        )
      end
    end

    def self.home_page_viewed(user, cookies)
      if user.nil?
        SegmentClient.track(
          anonymous_id: cookies[:uuid],
          event: "home_page_viewed"
        )
      else
        SegmentClient.track(
          user_id: user.hashid,
          anonymous_id: cookies[:uuid],
          event: "home_page_viewed"
        )
      end
    end

    def self.open_page_viewed(user, cookies)
      if user.nil?
        SegmentClient.track(
          anonymous_id: cookies[:uuid],
          event: "open_page_viewed"
        )
      else
        SegmentClient.track(
          user_id: user.hashid,
          anonymous_id: cookies[:uuid],
          event: "open_page_viewed"
        )
      end
    end

    def self.conversation_shown(user, cookies, conversation)
      SegmentClient.track(
        user_id: user.hashid,
        anonymous_id: cookies[:uuid],
        event: "conversation_shown",
        properties: {conversation: conversation.attributes}
      )
    end

    def self.message_created(user, cookies, message)
      SegmentClient.track(
        user_id: user.hashid,
        anonymous_id: cookies[:uuid],
        event: "message_created",
        properties: {message: message.attributes}
      )
    end

    def self.notifications_viewed(user, cookies)
      SegmentClient.track(
        user_id: user.hashid,
        anonymous_id: cookies[:uuid],
        event: "notifications_viewed"
      )
    end

    def self.pricing_viewed(user, cookies)
      if user.nil?
        SegmentClient.track(
          anonymous_id: cookies[:uuid],
          event: "pricing_viewed"
        )
      else
        SegmentClient.track(
          user_id: user.hashid,
          anonymous_id: cookies[:uuid],
          event: "pricing_viewed"
        )
      end
    end

    def self.affiliate_program_viewed(user, cookies)
      if user.nil?
        SegmentClient.track(
          anonymous_id: cookies[:uuid],
          event: "affiliate_program_viewed"
        )
      else
        SegmentClient.track(
          user_id: user.hashid,
          anonymous_id: cookies[:uuid],
          event: "affiliate_program_viewed"
        )
      end
    end

    def self.developer_public_profile_viewed(user, cookies, developer_id)
      if user.nil?
        SegmentClient.track(
          anonymous_id: cookies[:uuid],
          event: "developer_public_profile_viewed",
          properties: {developer_id: developer_id}
        )
      else
        SegmentClient.track(
          user_id: user.hashid,
          anonymous_id: cookies[:uuid],
          event: "developer_public_profile_viewed",
          properties: {developer_id: developer_id}
        )
      end
    end

    def self.referral_created(user, cookies, ref_code)
      SegmentClient.track(
        user_id: user.hashid,
        anonymous_id: cookies[:uuid],
        event: "referral_created",
        properties: {code: ref_code}
      )
    end

    def self.developer_response_rate_updated(developer_id, rate)
      SegmentClient.track(
        user_id: developer_id,
        event: "developer_response_rate_updated",
        properties: {rate: rate}
      )
    end

    def self.hiring_invoice_request_created(user, cookies, form)
      SegmentClient.track(
        user_id: user.hashid,
        anonymous_id: cookies[:uuid],
        event: "hiring_invoice_request_created",
        properties: {form: form.attributes}
      )
    end

    def self.affiliate_registration_created(user, cookies)
      SegmentClient.track(
        user_id: user.hashid,
        anonymous_id: cookies[:uuid],
        event: "affiliate_registration_created"
      )
    end

    def self.goals
      Rails.configuration.analytics
    end

    def tracked?
      tracked_at.present?
    end

    def track!
      touch(:tracked_at)
    end
  end
end
