class Folder < ActiveRecord::Base
  attr_accessible :bookmark_id, :name, :user_id
end
