class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body

  belongs_to :issue
end
