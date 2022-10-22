class AddTaskStatusToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :task_status, :integer, default: 0
  end
end
