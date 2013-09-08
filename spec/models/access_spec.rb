require 'spec_helper'

describe Access do
  subject { Factory(:access) }

  it { should validate_presence_of :user_id }
  it { should validate_presence_of :company_id }

  describe "when added without roles default role :user is added" do
    access = Factory(:access)
    access.roles.include?(:user).should == true
  end

  describe "active should be true after create" do
    access = Factory(:access)
    access.active.should == true
  end

end

# == Schema Information
#
# Table name: accesses
#
#  id         :integer         not null, primary key
#  user_id    :integer         not null
#  company_id :integer         not null
#  roles      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  active     :boolean         default(TRUE)
#  email      :string(100)
#  first_name :string(32)
#  last_name  :string(32)
#

