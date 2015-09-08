class User < ActiveRecord::Base
  has_secure_password

  validates :username, presence: true, uniqueness: true
  validates :password_confirmation, presence: true, if: :changed_password?

  has_many :issues, foreign_key: :creator_id
  has_many :comments, foreign_key: :creator_id

  private

  def changed_password?
    changed.include?('password_digest')
  end
end
