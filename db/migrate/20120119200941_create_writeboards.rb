class CreateWriteboards < ActiveRecord::Migration
  def up
    create_table :writeboards do |t|
      t.integer :access_id
      t.integer :company_id
      t.boolean :public_access
      t.boolean :editable_admins
      t.boolean :editable_users
      t.string  :title
      t.text    :body
      t.timestamps
    end
    add_index "writeboards", ["access_id"], :name => "index_writeboards_on_access_id"
    add_index "writeboards", ["company_id"], :name => "index_writeboards_on_company_id"
  end

  def down
    drop_table :writeboards
  end
end
