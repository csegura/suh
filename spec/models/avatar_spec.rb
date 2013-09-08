require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Avatar do

  before(:each) do
    @user = Factory(:user)
    @company = Factory(:company)
  end

  it "should create a new instance given valid attributes" do
    Factory(:avatar, :entity => @user).should be_valid
  end

  it "user should have one avatar as entity" do
    avatar = Factory(:avatar, :entity => @user)
    @user.avatar.should == avatar
  end

  it "company should have one avatar as entity" do
    avatar = Factory(:avatar, :entity => @company)
    @company.avatar.should == avatar
  end

  it "user might have many avatars as owner" do
    avatars = [
        Factory(:avatar, :user=> @user, :entity => @user),
        Factory(:avatar, :user=> @user, :entity => @company)
    ]
    @user.avatars.should == avatars
  end

end
# == Schema Information
#
# Table name: avatars
#
#  id                 :integer         not null, primary key
#  user_id            :integer
#  entity_id          :integer
#  entity_type        :string(255)
#  image_file_size    :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

