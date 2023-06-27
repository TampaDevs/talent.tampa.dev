module Stripe
  class CheckoutsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_signed_hiring_agreement!
    before_action :require_business_profile!

    def create
      redirect_to BusinessSubscriptionCheckout.new(
        user: current_user,
        plan: params[:plan],
        success_path: stored_location_for(:user)
      ).url, allow_other_host: true
    end

    private

    def require_business_profile!
      if current_user.business.nil? or !current_user.business.present?
        redirect_to new_business_path, notice: I18n.t("errors.business_subscription_no_profile")
      end
    end

    def require_signed_hiring_agreement!
      if current_user.needs_to_sign_hiring_agreement?
        redirect_to new_hiring_agreement_signature_path, notice: I18n.t("errors.hiring_agreements.payment")
      end
    end
  end
end
