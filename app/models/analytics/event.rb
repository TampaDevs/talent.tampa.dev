module Analytics
  class Event < ApplicationRecord
    self.table_name = "analytics_events"

    validates :url, presence: true
    validates :goal, presence: true
    validates :value, presence: true, numericality: {greater_than_or_equal_to: 0}

    def self.user_signed_in(user, cookies)
      SegmentClient.identify(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        traits: {
          **user.analytics_profile_identify_traits,
          **user.attributes
        }
      )
      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "user_signed_in",
        properties: {
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.user_signed_out(user, cookies)
      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "user_signed_out",
        properties: {
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.user_registered(user, cookies)
      SegmentClient.identify(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        traits: {
          **user.analytics_profile_identify_traits,
          **user.attributes
        }
      )
      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "user_registered",
        properties: {
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.added_developer_profile(url, cookies, developer)
      SegmentClient.track(
        user_id: developer.analytics_profile[:ap_stable_id],
        event: "developer_profile_added",
        properties: {
          user: {
            **developer.analytics_profile,
            **developer.attributes
          }
        }
      )
      Analytics::Event.create!(url:, goal: goals.added_developer_profile)
    end

    def self.added_business_profile(url, cookies, business)
      SegmentClient.track(
        user_id: business.analytics_profile[:ap_stable_id],
        event: "business_profile_added",
        properties: {
          business: {
            **business.analytics_profile,
            **business.attributes
          }
        }
      )
      Analytics::Event.create!(url:, goal: goals.added_business_profile)
    end

    def self.subscribed_to_busines_plan(url, user, value:)
      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        event: "business_plan_checkout_started",
        properties: {
          value: value,
          path: url,
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
      Analytics::Event.create!(url:, goal: goals.subscribed_to_busines_plan, value: value * 100)
    end

    def self.subscription_created(business, customer)
      SegmentClient.track(
        user_id: business.analytics_profile[:ap_stable_id],
        event: "business_plan_subscribe_success",
        properties: {
          business: {
            **business.analytics_profile,
            **business.attributes
          },
          customer: {
            **customer.attributes
          }
        }
      )
    end

    def self.subscription_canceled(business, customer)
      SegmentClient.track(
        user_id: business.analytics_profile[:ap_stable_id],
        event: "business_plan_subscribe_cancel",
        properties: {
          customer: {
            **customer.attributes
          },
          business: {
            **business.attributes,
            **business.analytics_profile
          }
        }
      )
    end

    def self.celebration_package_requested(developer, cookies, form)
      SegmentClient.track(
        user_id: developer.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "celebration_package_requested",
        properties: {
          user: {
            **developer.analytics_profile,
            **developer.attributes
          },
          form: {
            **form.attributes
          }
        }
      )
    end

    def self.developers_search_queried(user, cookies, query, num_results)
      if user.nil?
        return
      end

      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "developer_search_queried",
        properties: {
          query: query,
          num_results: num_results,
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.developers_profile_shown(user, cookies, id)
      if user.nil?
        return
      end

      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "developers_profile_shown",
        properties: {
          id: id,
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.developers_page_viewed(user, cookies)
      if user.nil?
        return
      end

      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "developers_page_viewed",
        properties: {
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.developer_profile_updated(user, cookies, params)
      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "developer_profile_updated",
        properties: {
          profile: {**params.to_h},
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.business_profile_updated(user, cookies, business)
      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "business_profile_updated",
        properties: {
          business: {
            **business.attributes
          },
          user: {
            **user.attributes,
            **user.analytics_profile
          }
        }
      )
    end

    def self.hiring_agreement_signature_created(user, cookies, signature)
      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "hiring_agreement_signature_created",
        properties: {
          **signature.to_h,
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.cold_message_created(user, cookies, message)
      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "cold_message_created",
        properties: {
          message: {**message.attributes},
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.block_created(user, cookies, conversation, other_recipient)
      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "block_created",
        properties: {
          conversation: {**conversation.attributes},
          other_recipient: other_recipient,
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.about_page_viewed(user, cookies)
      if user.nil?
        return
      end

      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "about_page_viewed",
        properties: {
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.tos_page_viewed(user, cookies)
      if user.nil?
        return
      end

      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "tos_page_viewed",
        properties: {
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.privacy_page_viewed(user, cookies)
      if user.nil?
        return
      end

      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "privacy_page_viewed",
        properties: {
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.home_page_viewed(user, cookies)
      if user.nil?
        return
      end

      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "home_page_viewed",
        properties: {
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.open_page_viewed(user, cookies)
      if user.nil?
        return
      end

      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "open_page_viewed",
        properties: {
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.conversation_shown(user, cookies, conversation)
      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "conversation_shown",
        properties: {
          conversation: {**conversation.attributes},
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.message_created(user, cookies, message)
      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "message_created",
        properties: {
          message: {**message.attributes},
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.notifications_viewed(user, cookies)
      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "notifications_viewed",
        properties: {
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.pricing_viewed(user, cookies)
      if user.nil?
        return
      end

      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "pricing_viewed",
        properties: {
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.affiliate_program_viewed(user, cookies)
      if user.nil?
        return
      end

      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "affiliate_program_viewed",
        properties: {
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.developer_public_profile_viewed(user, cookies, developer_id)
      if user.nil?
        return
      end

      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "developer_public_profile_viewed",
        properties: {
          developer_id: developer_id,
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.referral_created(user, cookies, ref_code)
      if user.nil?
        return
      end

      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "referral_created",
        properties: {
          code: ref_code,
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
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
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "hiring_invoice_request_created",
        properties: {
          form: {**form.attributes},
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
      )
    end

    def self.affiliate_registration_created(user, cookies)
      SegmentClient.track(
        user_id: user.analytics_profile[:ap_stable_id],
        anonymous_id: cookies[:uuid],
        event: "affiliate_registration_created",
        properties: {
          user: {
            **user.analytics_profile,
            **user.attributes
          }
        }
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
