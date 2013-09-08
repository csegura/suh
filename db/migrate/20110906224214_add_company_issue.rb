class AddCompanyIssue < ActiveRecord::Migration
  def up
    add_column :issues, :company_id, :integer
    add_index "issues", ["company_id"], :name => "index_issues_on_company_id"
  end

  def down
    remove_column :issues, :company_id
  end
end
