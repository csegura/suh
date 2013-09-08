class CreateTableTimetracks < ActiveRecord::Migration
  def up
      create_table "timetracks", :force => true do |t|
        t.integer  "access_id"
        t.integer  "company_id"
        t.text     "body"
        t.boolean  "confirmed",  :default => false
        t.string   "code", :length => 10
        t.integer  "confirmed_by"
        t.datetime "confirmed_at"
        t.datetime "tracked_at"
        t.datetime "deleted_at"
        t.integer  "minutes"
        t.integer  "trackable_id"
        t.string   "trackable_type"
        t.boolean  "billable", :default => false
        t.timestamps
      end
      add_index "timetracks", ["access_id"], :name => "index_timetracks_on_access_id"
      add_index "timetracks", ["trackable_id", "trackable_type"], :name => "index_timetracks_on_trackable"
    end

    def down
      drop_table "timetracks"
    end
end
