class Category < ActiveRecord::Base
  belongs_to :company
  acts_as_list :scope => :company

  validates :name,
            :presence => true

  default_scope :order => :position
  scope :for_company,
        lambda {|company| where(:company_id => company.id) }

end
# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  company_id :integer
#  name       :string(90)      not null
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

