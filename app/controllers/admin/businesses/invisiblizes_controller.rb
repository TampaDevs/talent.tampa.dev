module Admin
  module Businesses
    class InvisiblizesController < ApplicationController
      def create
        business = Business.find(params[:business_id])
        business.toggle_visibility_and_notify!

        redirect_to business_path(business), notice: business.invisible? ? t(".created") : t(".destroyed")
      end
    end
  end
end
