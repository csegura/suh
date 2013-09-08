class ChangeWriteboardColumnsDefaults < ActiveRecord::Migration
  def self.up
    change_column :writeboards, :public_access, :boolean, :default => false
    change_column :writeboards, :editable_admins, :boolean, :default => false
    change_column :writeboards, :editable_users, :boolean, :default => false
  end

  def down
  end
end
