class AddCommentCompanyId < ActiveRecord::Migration
  def up
    add_column :comments, :company_id, :integer
    add_index :comments, [:company_id], :name => "index_comments_on_company_id"
  end

  def down
    remove_column :comments, :company_id
  end
end
