class Comment < ActiveRecord::Base
  belongs_to :issue

  validates :body, presence: true
end
