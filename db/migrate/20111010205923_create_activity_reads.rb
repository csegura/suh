class CreateActivityReads < ActiveRecord::Migration
  def up
    create_table :activity_reads do |t|
      t.integer :activity_id
      t.integer :user_id
    end
    add_index :activity_reads, [:activity_id, :user_id], :name => "index_activity_reads_on_activity_id_and_user_id"
  end

  def down
    drop_table :activity_reads
  end
end
