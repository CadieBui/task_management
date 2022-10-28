class AddUseridToTask < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_column :tasks, :userid, :uuid
    add_index :tasks, :userid, :algorithm => :concurrently
  end
end
