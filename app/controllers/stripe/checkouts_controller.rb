module Stripe
  class CheckoutsController < ApplicationController
    include CheckoutHelper

    before_action :authenticate_user!
    before_action :require_signed_hiring_agreement!
    before_action :require_business_profile!

    def create
      redirect_to new_checkout_path(user: current_user, plan: params[:plan], success_path: stored_location_for(:user)), allow_other_host: true
      checkout_flow_completed!
    end

    private

    def require_business_profile!
      if current_user.business.nil? || !current_user.business.present?
        checkout_flow_setup
        redirect_to new_business_path, notice: I18n.t("errors.business_subscription_no_profile")
      end
    end

    def require_signed_hiring_agreement!
      if current_user.needs_to_sign_hiring_agreement?
        checkout_flow_setup
        redirect_to new_hiring_agreement_signature_path, notice: I18n.t("errors.hiring_agreements.payment")
      end
    end

    def checkout_flow_setup
      if current_user.business.nil? || !current_user.business.present?
        checkout_flow_start!
        store_location_for(current_user, new_business_path)
      end
    end
  end
end
