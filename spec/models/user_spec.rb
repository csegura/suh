require 'spec_helper'

describe User do
  subject { Factory(:user) }

  it { should validate_presence_of(:email) }
  #it { should validate_uniqueness_of(:email) }

  it { should have_one :user_profile }
  it { should have_one :avatar }
  it { should have_many :avatars }

  describe "authentication" do
    before do
      @email = 'sample@email.com'
      @password = 'password'
      @user = Factory(:user, :email => @email, :password => @password, :password_confirmation => @password)
    end

    it "should have a password_digest" do
      @user.password_digest.should_not be_nil
    end

    it "should return the user object for a valid login using his username" do
      @user.authenticate(@password).should == @user
    end

    it "should return false incorrect login attempts" do
      @user.authenticate("bad_password").should be_false
      @user.authenticate("").should be_false
    end

    it "should be active when has set a password" do
      @user.active?.should be_true
    end
  end

  describe "activation" do
    before do
      @email = 'sample@email.com'
      @password = ''
      @user = Factory.build(:user, :email => @email, :password => @password, :password_confirmation => @password)
      @user.save(:validations => false)
    end

    it "should not have a password_digest" do
      @user.password_digest.should be_nil
    end

    it "should be inactive" do
      @user.active?.should be_false
    end

    describe "send activation email" do
      before do
        @user.password_reset_token = nil
        @user.password_reset_sent_at = nil
      end

      it "should send a password reset mail" do
        #UserMailer.should deliver(:password_reset).with(@user)
        @user.send_password_reset
        last_email.to.should include(@user.email)
        last_email.body.should include(@user.password_reset_token)
      end

      it "should generate a valid login token for the email" do
        @user.send_password_reset
        @user.password_reset_token.should_not be_nil
        @user.password_reset_sent_at.should_not be_nil
      end
    end

  end

end

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(100)     not null
#  first_name             :string(32)
#  last_name              :string(32)
#  password_digest        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  auth_token             :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  last_login_at          :datetime
#  last_login_ip          :string(32)
#

