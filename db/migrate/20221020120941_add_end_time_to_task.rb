class AddEndTimeToTask < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :endtime, :datetime
  end
end
