module Admin
  module Businesses
    class InvisiblizesController < ApplicationController
      def create
        business = Business.find(params[:business_id])
        business.invisiblize_and_notify!
        redirect_to business_path(business), notice: t(".created")
      end
    end
  end
end
