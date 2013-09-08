
class CreateWriteboardVersions < ActiveRecord::Migration
  def self.up
    create_table :writeboard_versions do |t| 
      
      t.column :access_id, :integer
      
      t.column :company_id, :integer
      
      t.column :public_access, :boolean
      
      t.column :editable_admins, :boolean
      
      t.column :editable_users, :boolean
      
      t.column :title, :string
      
      t.column :body, :text
      
      t.integer :writeboard_id
      t.integer :versioned_as
      t.timestamps
    end

    add_index :writeboard_versions, :versioned_as
    add_column :writeboards, :current_version, :integer
  end

  def self.down
    drop_table :writeboard_versions
    remove_column :writeboards, :current_version
  end
end
