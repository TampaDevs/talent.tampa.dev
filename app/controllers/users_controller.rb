class UsersController < Devise::RegistrationsController
  include Referrals

  invisible_captcha only: :create

  def create
    super do |user|
      Analytics::Event.user_registered(user, cookies) if user.valid?
      create_referral(user) if user.valid?
    end
  end
end
