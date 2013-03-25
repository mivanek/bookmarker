class Bookmark < ActiveRecord::Base
  attr_accessible :description, :title, :url, :user_id
end
