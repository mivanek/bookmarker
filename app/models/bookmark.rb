class Bookmark < ActiveRecord::Base
  attr_accessible :description, :title, :url, :user_id

  VALID_PROTOCOLS = ["http://", "https://", "ftp://"]

  validates :title, presence: true
  validates :url, presence: true
  validates :description, presence: true
  validate :url_validation

  private

    def url_validation
      errors.add(:url, "can't be empty") and return if self.url.blank?
      protocol = self.url.scan(/^\w+\:\/\//).first.downcase
      unless VALID_PROTOCOLS.include? protocol
        errors.add(:url, "is invalid (invalid protocol)")
      end
    end
end
