class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { self.email.downcase! }
  before_save :create_remember_token

  has_many :bookmarks, dependent: :destroy

  validates :email, presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 30 }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
