class Folder < ActiveRecord::Base
  attr_accessible :bookmark_id, :name, :user_id

  belongs_to :users
  belongs_to :bookmarks
end
