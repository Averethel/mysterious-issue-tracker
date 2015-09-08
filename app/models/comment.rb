class Comment < ActiveRecord::Base
  belongs_to :issue
  belongs_to :creator, class_name: User

  validates :body, presence: true
end
