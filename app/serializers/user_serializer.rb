class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :name, :surname, :role, :created_at, :updated_at

  has_many :issues
  has_many :assigned_issues
  has_many :comments
end
