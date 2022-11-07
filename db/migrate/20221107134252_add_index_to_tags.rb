class AddIndexToTags < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :tags, :tagname, :algorithm => :concurrently
  end
end
