class DeleteWriteboardVersions < ActiveRecord::Migration
  def up
    drop_table :writeboard_versions
  end

  def down
  end
end
