class AddClosedColumnToFolders < ActiveRecord::Migration
  def up
    add_column :folders, :closed, :boolean, default: :false
    @folders = Folder.all
    @folders.each do |folder|
      folder.closed = false
      folder.save
    end
  end

  def down
    remove_column :folders, :closed
  end
end
