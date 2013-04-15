class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.integer :user_id
      t.integer :bookmark_id
      t.string :name

      t.timestamps
    end
    add_index :folders, :user_id
    add_index :folders, :bookmark_id
    add_index :folders, [:user_id, :bookmark_id], unique: true
  end
end
