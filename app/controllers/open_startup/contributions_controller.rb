module OpenStartup
  class ContributionsController < ApplicationController
    def index
      @to_communities = Transaction.contribution.sum(:amount)
      @to_co2_removal = StripeTransaction.contribution.sum(:amount)
      @contributions = Contribution.order(occurred_on: :desc)

      @climate_url = "https://climate.stripe.com/nxdibE"
      Analytics::Event.open_page_viewed(current_user, cookies)
    end
  end
end
