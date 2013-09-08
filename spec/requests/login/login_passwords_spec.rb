require 'spec_helper'

describe "Login::Passwords" do

  describe "PasswordResets" do
    it "emails user when requesting password reset" do
      user = Factory(:user)
      visit log_in_path
      click_link t("session.forgot_password")
      fill_in "email", :with => user.email
      click_button t("session.remember_password")
      current_path.should eq(log_in_path)
      page.should have_content(t("session.sent_instructions"))
      last_email.to.should include(user.email)
    end

    it "does not email invalid user when requesting password reset" do
      visit log_in_path
      click_link t("session.forgot_password")
      fill_in "email", :with => "nobody@example.com"
      click_button t("session.remember_password")
      current_path.should eq(log_in_path)
      page.should have_content(t("session.sent_instructions"))
      last_email.should be_nil
    end

    # I added the following specs after recording the episode. It literally
    # took about 10 minutes to add the tests and the implementation because
    # it was easy to follow the testing pattern already established.
    it "updates the user password when confirmation matches" do
      user = Factory(:user, :password_reset_token => "something", :password_reset_sent_at => 1.hour.ago)
      visit log_edit_path(user.password_reset_token)
      fill_in "user_password", :with => "foobar"
      click_button t("session.update_password")
      page.should have_content(t("activerecord.errors.messages.confirmation"))
      fill_in "user_password", :with => "foobar"
      fill_in "user_password_confirmation", :with => "foobar"
      click_button t("session.update_password")
      page.should have_content(t("session.password_reset"))
    end

    it "reports when password token has expired" do
      user = Factory(:user, :password_reset_token => "something", :password_reset_sent_at => 5.hour.ago)
      visit log_edit_path(user.password_reset_token)
      fill_in "user_password", :with => "foobar"
      fill_in "user_password_confirmation", :with => "foobar"
      click_button t("session.update_password")
      page.should have_content(t("session.token_expired"))
    end

    it "raises record not found when password token is invalid" do
      lambda {
        visit log_edit_path("invalid")
      }.should raise_exception(ActiveRecord::RecordNotFound)
    end
  end
end
