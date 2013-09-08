class CreateComments < ActiveRecord::Migration
  def up
    create_table "comments", :force => true do |t|
      t.text "comment"
      t.integer "access_id", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "commentable_id"
      t.string "commentable_type"
    end

    add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable"
    add_index "comments", ["access_id"], :name => "index_comments_on_access_id"
  end

  def down
    drop_table :comments
  end
end
