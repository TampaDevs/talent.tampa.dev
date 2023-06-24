module Referrals
  extend ActiveSupport::Concern

  included do
    before_action :set_ref_cookie
  end

  def set_ref_cookie
    if params[:ref].present?
      cookies[:ref] = {value: params[:ref], expires: 30.days}
    end
  end

  def create_referral(user)
    if cookies[:ref].present?
      user.create_referral!(code: cookies[:ref])
      Analytics::Event.referral_created(current_user, cookies, cookies[:ref])
    end
  end
end
