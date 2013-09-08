class Writeboard < ActiveRecord::Base
  include BelongsToAccess
  include BelongsToCompany


  acts_as_versionable :max_versions => 10

  validates :title, :presence => true

  def self.create_new_writeboard company, access, params
    Writeboard.new(params) do |issue|
      issue.company = company unless params[:company_id]
      issue.access = access unless params[:access_id]
    end
  end

end
# == Schema Information
#
# Table name: writeboards
#
#  id              :integer         not null, primary key
#  access_id       :integer
#  company_id      :integer
#  public_access   :boolean
#  editable_admins :boolean
#  editable_users  :boolean
#  title           :string(255)
#  body            :text
#  created_at      :datetime
#  updated_at      :datetime
#  current_version :integer
#

