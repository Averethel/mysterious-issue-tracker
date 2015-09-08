class IssuePolicy < ApplicationPolicy
  def create?
    !user.guest?
  end

  def update?
    admin_or_creator?
  end

  def destroy?
    admin_or_creator?
  end

  def permitted_attributes
    base_attributes
  end

  private

  def admin_or_creator?
    user.admin? || user.id == record.creator_id
  end

  def base_attributes
    [:assignee_id, :title, :description, :priority, :status]
  end
end
