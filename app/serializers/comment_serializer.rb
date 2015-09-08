class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  belongs_to :issue
  belongs_to :creator
end
