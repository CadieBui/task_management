class AddUuidToUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')
    add_column :users, :uuid, :uuid, default: "uuid_generate_v4()", null: false
    change_table :users do |t|
      t.remove :id
      t.rename :uuid, :id
    end
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"
  end
end
