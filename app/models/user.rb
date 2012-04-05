class User < ActiveRecord::Base
  attr_accessible :username, :password, :password_confirmation
  has_secure_password
  before_save :create_remember_token

  has_many :assignments
  has_many :comments
  has_many :time_entries
  has_many :paid_time_entries

  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
