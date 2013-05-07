class Bookmark < ActiveRecord::Base
  attr_accessible :description, :title, :url, :user_id, :folder_id, :sequence

  before_save { self.url.downcase }
  before_save :add_sequence, if: 'new_record?'

  belongs_to :users
  belongs_to :folder

  VALID_PROTOCOLS = /^(http|https|ftp)\:\/\//i

  default_scope order: 'sequence'

  validates :title, presence: true
  validates :url, presence: true
  validates :url, format: {
    with: VALID_PROTOCOLS,
    message: "The URL does not have a valid protocol." }
  validates :user_id, presence: true


  private

    def add_sequence
      bookmarks = Bookmark.find_all_by_user_id(user_id)
      unless bookmarks.blank?
        bookmarks.each do |bookmark|
          bookmark.sequence += 1
          bookmark.save
        end
      end
      self.sequence = 1
    end

end
