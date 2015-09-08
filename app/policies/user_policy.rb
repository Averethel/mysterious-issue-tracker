class UserPolicy < ApplicationPolicy
  def create?
    true
  end

  def me?
    true
  end

  def update?
    admin_or_self?
  end

  def destroy?
    admin_or_self?
  end

  def permitted_attributes
    if user.admin?
      [:role] + base_attributes
    else
      [base_attributes]
    end
  end

  private

  def admin_or_self?
    user.admin? || record.id == user.id
  end

  def base_attributes
    [:username, :name, :surname, :password, :password_confirmation]
  end
end
