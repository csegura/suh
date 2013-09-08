class ChangeActivity < ActiveRecord::Migration
  def up
    rename_column :activities, :target_user_id, :user_id
    rename_column :activities, :target_company_id, :company_id
    Activity.all.each do |activity|
      activity.user_id = activity.access.user_id
      activity.company_id = activity.access.company_id
      activity.save
    end
  end

  def down
    rename_column :activities, :user_id, :target_user_id
    rename_column :activities, :company_id, :target_company_id
  end
end
