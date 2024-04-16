class Businesses::JobPostPolicy < ApplicationPolicy
  def edit?
    record_owner? || admin?
  end

  def update?
    edit?
  end
end
