class RemoveBookmarkIdFromFolders < ActiveRecord::Migration
  def up
    remove_index :folders, :bookmark_id
    remove_index :folders, [:user_id, :bookmark_id]
    remove_column :folders, :bookmark_id
  end

  def down
    add_column :folders, :bookmark_id
    add_index :folders, :bookmark_id
    add_index :folders, [:user_id, :bookmark_id], unique: true
  end
end
