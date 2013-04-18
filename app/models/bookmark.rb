class Bookmark < ActiveRecord::Base
  attr_accessible :description, :title, :url, :user_id

  before_save { self.url.downcase }

  belongs_to :users
  has_one :folder

  VALID_PROTOCOLS = /^(http|https|ftp)\:\/\//i

  default_scope order: 'sequence'

  validates :title, presence: true
  validates :url, presence: true
  validates :description, presence: true
  validates :url, format: {
    with: VALID_PROTOCOLS,
    message: "The URL does not have a valid protocol." }
  validates :user_id, presence: true

end
