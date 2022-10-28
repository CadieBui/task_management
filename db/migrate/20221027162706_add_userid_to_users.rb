class AddUseridToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :userid, :uuid, default: "uuid_generate_v4()", null: false
    change_table :users do |t|
      t.remove :id
      t.rename :userid, :id
    end
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"
  end
end
