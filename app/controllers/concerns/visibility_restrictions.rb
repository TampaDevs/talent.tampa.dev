module VisibilityRestrictions
  extend ActiveSupport::Concern
  def require_business_not_invisible!
    if current_user.business.present? && current_user.business.invisible?
      store_location!
      redirect_to root_path, alert: I18n.t("errors.business_invisible")
    end
  end

  def require_developer_not_invisible!
    if current_user.developer.present? && current_user.developer.invisible?
      store_location!
      redirect_to root_path, alert: I18n.t("errors.developer_invisible")
    end
  end

  def require_developer_and_business_not_invisible!
    require_business_not_invisible! && require_developer_not_invisible!
  end
end