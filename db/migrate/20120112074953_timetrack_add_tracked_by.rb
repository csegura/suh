class TimetrackAddTrackedBy < ActiveRecord::Migration
  def up
    add_column :timetracks, :tracked_by, :integer
  end

  def down
    remove_column :timetracks, :tracked_by
  end
end
