class ApplicationController < ActionController::Base
  include DeviceFormat
  include HoneybadgerUserContext
  include Locales
  include Pundit::Authorization
  include Referrals
  include StoredLocation

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  around_action :set_locale
  before_action :redirect_suspended_accounts
  before_action :set_variant
  before_action :set_uuid

  helper_method :resolve_locale
  helper_method :turbo_native_app?

  impersonates :user

  def after_sign_in_path_for(user)
    Analytics::Event.user_signed_in(user, cookies)
    if (stored_location = stored_location_for(:user)).present?
      stored_location
    elsif user.developer.present? || user.business.present?
      super
    else
      new_role_path
    end
  end

  def user_not_authorized
    flash[:alert] = I18n.t("errors.unauthorized")
    redirect_back_or_to root_path, allow_other_host: false
  rescue ActionController::Redirecting::UnsafeRedirectError
    redirect_to root_path
  end

  def redirect_suspended_accounts
    if current_user&.suspended?
      redirect_to users_suspended_path
    end
  end

  def set_variant
    if Feature.enabled?(:redesign)
      request.variant = :redesign
    end
  end

  def set_uuid
    cookies[:uuid] = SecureRandom.uuid unless cookies[:uuid]
  end
end
