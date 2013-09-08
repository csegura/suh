class ChangeNotesField < ActiveRecord::Migration
  def up
    remove_column :notes, :note
    add_column :notes, :note, :text
    add_column :notes, :private, :bool, :default => true
  end

  def down
    add_column :notes, :note, :text
  end
end
