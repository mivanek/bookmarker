class AddDemoAccountColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :demo, :boolean, default: false
    add_index :users, :demo
  end
end
