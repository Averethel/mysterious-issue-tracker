class CommentPolicy < ApplicationPolicy
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
    [:body]
  end

  private

  def admin_or_creator?
    user.admin? || user.id == record.creator_id
  end
end
