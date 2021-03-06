class IssueSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :description,
             :priority,
             :status,
             :created_at,
             :updated_at

  has_many :comments
  belongs_to :creator
  belongs_to :assignee
end
