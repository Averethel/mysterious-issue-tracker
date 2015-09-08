class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :name, :surname, :created_at, :updated_at

  has_many :issues
  has_many :comments
end
