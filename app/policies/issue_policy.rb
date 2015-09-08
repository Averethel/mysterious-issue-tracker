class IssuePolicy < ApplicationPolicy
  def create?
    !user.guest?
  end

  def take?
    !user.guest?
  end

  def free?
    admin_or_creator? || assignee?
  end

  def update?
    admin_or_creator? || assignee?
  end

  def destroy?
    admin_or_creator?
  end

  def permitted_attributes
    return base_attributes if admin_or_creator?
    return [:status] if assignee?
    base_attributes
  end

  private

  def admin_or_creator?
    user.admin? || user.id == record.creator_id
  end

  def assignee?
    user.id == record.assignee_id
  end

  def base_attributes
    [:assignee_id, :title, :description, :priority, :status]
  end
end
