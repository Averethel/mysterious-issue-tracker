class Issue < ActiveRecord::Base
  has_many :comments
  belongs_to :creator, class_name: User

  enum priority: [:minor, :major, :critical, :blocker]
  enum status: [:open, :in_progress, :fixed, :rejected]

  validates :title, :description, :priority, :status, presence: true
  validate :ensure_status_open, on: :create

  private

  def ensure_status_open
    return if open?

    errors.add(:status, "must be 'open'")
  end
end
