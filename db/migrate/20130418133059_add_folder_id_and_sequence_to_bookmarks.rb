class AddFolderIdAndSequenceToBookmarks < ActiveRecord::Migration
  def change
    add_column :bookmarks, :folder_id, :integer, default: 0
    add_column :bookmarks, :sequence, :integer
  end
end
