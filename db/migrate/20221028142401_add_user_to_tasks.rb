class AddUserToTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :tasks, :user, foreign_key: true, type: :uuid
  end
end
