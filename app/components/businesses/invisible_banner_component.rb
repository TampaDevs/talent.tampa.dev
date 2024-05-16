module Businesses
  class InvisibleBannerComponent < ApplicationComponent
    include ComponentWithIcon

    attr_reader :user

    def initialize(user)
      @user = user
      @support_email = Rails.configuration.emails.support!
    end

    def render?
      invisible? && persisted?
    end

    private

    def persisted?
      user.business.persisted?
    end

    def invisible?
      user&.business&.invisible?
    end
  end
end
