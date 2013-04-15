class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { self.email.downcase! }
  before_save :create_remember_token

  has_many :bookmarks, dependent: :destroy
  has_many :folders

  validates :email, presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 30 }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  after_create :populate_with_default_bookmarks


  def populate_with_default_bookmarks
    default_websites.each do |website|
      title, description, url = parser(website).parse
      bookmark = self.bookmarks.build(title: title, description: description,
                           url: url)
      bookmark.save
    end
  end

  private

    def default_websites
      %w(http://www.ebay.com http://www.amazon.com http://www.google.com
         http://www.wikipedia.org http://www.facebook.com http://www.youtube.com)
    end

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def parser(website)
      ElementsParser.new(website)
    end
end
