module Affiliates
  class RegistrationsController < ApplicationController
    before_action :authenticate_user!, only: %w[new create]

    def index
      Analytics::Event.affiliate_program_viewed(current_user, cookies)
    end

    def new
      @registration = Registration.new
    end

    def create
      @registration = Registration.new(request_params)
      if @registration.valid?
        Admin::Affiliates::RegistrationNotification.with(user: current_user).deliver_later(User.admin)
        Analytics::Event.affiliate_registration_created(current_user, cookies)
        redirect_to affiliates_path, notice: t(".notice")
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def request_params
      params.require(:affiliates_registration).permit(:agreement)
    end
  end
end
