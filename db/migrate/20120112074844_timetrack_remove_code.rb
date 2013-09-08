class TimetrackRemoveCode < ActiveRecord::Migration
  def up
    remove_column :timetracks, :code
  end

  def down
    add_column :timetracks, :code, :length => 10
  end
end
