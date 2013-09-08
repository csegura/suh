class AddVersionToWriteboards < ActiveRecord::Migration
  def change
    add_column :writeboards, :version_number, :integer, :default => 0
    add_column :writeboards, :version_id, :integer, :default => nil
  end
end
