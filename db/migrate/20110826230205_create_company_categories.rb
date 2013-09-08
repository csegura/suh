class CreateCompanyCategories < ActiveRecord::Migration
  def up
    create_table "categories", :force => true do |t|
      t.integer   "company_id"
      t.string    "name", :limit => 90, :null => false
      t.integer   "position"
      t.timestamps
    end
    add_index "categories", ["company_id"], :name => "index_categories_on_company_id"
  end

  def down
    drop_table "categories"
  end
end
