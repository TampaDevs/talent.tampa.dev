class BusinessPolicy < ApplicationPolicy
  def update?
    record_owner?
  end

  def show?
    record.visible? || record_owner? || admin?
  end

  def permitted_attributes
    if user.permissions.active_subscription?
      default_attributes + notification_attributes
    else
      default_attributes
    end
  end

  private

  def default_attributes
    [
      :contact_name,
      :company,
      :bio,
      :avatar,
      :website,
      :phone_number,
      :contact_role,
      :survey_request_notifications
    ]
  end

  def notification_attributes
    [:developer_notifications]
  end
end
