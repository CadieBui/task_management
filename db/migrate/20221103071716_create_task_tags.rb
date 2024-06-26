class CreateTaskTags < ActiveRecord::Migration[7.0]
  def change
    create_table :task_tags do |t|
      t.references :task, null: false, foreign_key: true, type: :uuid
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end
  end
end
