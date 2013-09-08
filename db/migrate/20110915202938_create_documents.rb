class CreateDocuments < ActiveRecord::Migration
  def up
    create_table :documents, :force => true do |t|
      t.integer  "access_id"
      t.integer  "company_id"
      t.integer "category_id"
      t.text "comment"
      t.string "asset_file_name"
      t.string "asset_content_type"
      t.integer "asset_file_size"
      t.datetime "asset_updated_at"
      t.string "attachable_type"
      t.integer "attachable_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index :documents, ["access_id"], :name => "index_documents_on_access_id"
    add_index :documents, ["attachable_id", "attachable_type"], :name => "index_documents_on_attachable"
    add_index :documents, ["company_id"], :name => "index_documents_on_company_id"
  end

  def down
    drop_table :documents
  end
end
