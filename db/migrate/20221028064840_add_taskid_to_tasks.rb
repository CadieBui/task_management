class AddTaskidToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :taskid, :uuid, default: "uuid_generate_v4()", null: false
    change_table :tasks do |t|
      t.remove :id
      t.rename :taskid, :id
    end
    execute "ALTER TABLE tasks ADD PRIMARY KEY (id);"
  end
end
