require 'parser'

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :demo
  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { self.email.downcase! }
  before_save :create_remember_token

  has_many :bookmarks, dependent: :destroy
  has_many :folders, dependent: :destroy

  validates :email, presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :name, presence: true, length: { maximum: 30 }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  after_create :create_default_folders
  after_create :populate_with_default_bookmarks


  def populate_with_default_bookmarks
    default_websites.each do |website|
      title, description, url = parser(website).parse
      bookmark = self.bookmarks.build(title: title, description: description,
                           url: url)
      if url == facebook_url || url == twitter_url
        bookmark.folder_id = get_folder_id("Social Networks")
      elsif url == youtube_url
        bookmark.folder_id = get_folder_id("Videos")
      else
        bookmark.folder_id = get_folder_id("no_folder")
      end
      bookmark.save
    end
  end

  def create_default_folders
    default_folders.each do |folder_name|
      folder = self.folders.build(name: folder_name)
      folder.save
    end
  end

  private

    def get_folder_id(name)
      self.folders.where(name: name).first.id
    end

    def default_websites
      %w(http://www.ebay.com http://www.amazon.com http://www.google.com
         http://www.wikipedia.org http://www.facebook.com http://www.youtube.com
        http://www.twitter.com)
    end

    def youtube_url
      %q(http://www.youtube.com)
    end

    def facebook_url
      %q(http://www.facebook.com)
    end

    def twitter_url
      %q(http://www.twitter.com)
    end

    def default_folders
      %w(no_folder Videos Social\ Networks)
    end

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

    def parser(website)
      ElementsParser.new(website)
    end
end
