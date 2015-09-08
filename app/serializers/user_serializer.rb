class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :name, :surname, :created_at, :updated_at
end
