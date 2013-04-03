class Bookmark < ActiveRecord::Base
  attr_accessible :description, :title, :url, :user_id

  before_save { self.url.downcase }

  VALID_PROTOCOLS = /^(http|https|ftp)\:\/\//i

  validates :title, presence: true
  validates :url, presence: true
  validates :description, presence: true
  validates :url, format: {
    with: VALID_PROTOCOLS,
    message: "The URL does not have a valid protocol." }
end
