require 'spec_helper'

describe "Login::Sessions" do
  it "go home page when requested" do
    visit root_path
    current_path.should eq(root_path)
  end

  describe "Redirect to requested url after log in" do
    before(:each) do
      @user = Factory(:user)
    end

    it "when other page is requested" do
      visit me_path
      current_path.should eq(log_in_path)
      fill_login_form
      current_path.should eq(me_path)
    end
  end

  def fill_login_form
    fill_in "email", :with => @user.email
    fill_in "password", :with => @user.password
    click_button t("session.login")
  end
end
