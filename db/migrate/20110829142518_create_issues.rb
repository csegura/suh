class CreateIssues < ActiveRecord::Migration
  def up
  create_table "issues", :force => true do |t|
    t.string   "title",        :null => false
    t.text     "body"
    t.integer  "access_id"
    t.boolean  "open",         :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "closed_by"
    t.datetime "closed_at"
    t.integer  "comments_count", :default => 0
  end
  add_index :issues, ["access_id"], :name => "index_issues_on_access_id"
  add_index :issues, ["closed_by"], :name => "index_issues_on_closed_by"
  end

  def down
    drop_table :issues
  end
end
