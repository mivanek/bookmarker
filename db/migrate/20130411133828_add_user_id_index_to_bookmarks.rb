class AddUserIdIndexToBookmarks < ActiveRecord::Migration
  def change
    add_index :bookmarks, :user_id
  end
end
