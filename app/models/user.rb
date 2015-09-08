class User < ActiveRecord::Base
  has_secure_password

  enum role: [:user, :admin]

  validates :username, presence: true, uniqueness: true
  validates :password_confirmation, presence: true, if: :changed_password?
  validates :role, presence: true

  has_many :issues, foreign_key: :creator_id
  has_many :comments, foreign_key: :creator_id

  def role
    guest? ? :guest : super
  end

  def guest?
    new_record?
  end

  private

  def changed_password?
    changed.include?('password_digest')
  end
end
