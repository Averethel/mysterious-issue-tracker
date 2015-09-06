class IssueSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :description,
             :priority,
             :status,
             :created_at,
             :updated_at
end
