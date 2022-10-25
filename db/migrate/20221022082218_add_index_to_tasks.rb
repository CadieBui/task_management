class AddIndexToTasks < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :tasks, :task_status, :algorithm => :concurrently
  end
end
