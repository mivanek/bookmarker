class RemoveDefaultFromFolderId < ActiveRecord::Migration
  def up
    change_column_default(:bookmarks, :folder_id, nil)
  end

end
