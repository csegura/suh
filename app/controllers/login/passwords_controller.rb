class Login::PasswordsController < ApplicationController
  layout "login"

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    user.send_password_reset if user
    redirect_to log_in_url, :notice => t("session.sent_instructions")
  end

  def edit
    #@user = User.find_by_password_reset_token!(params[:id])
    @user = User.find(1)
  end

  def update
    @user = User.find(1)
    #@user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago && @user.active?
      redirect_to forgot_path, :alert => t("session.token_expired")
    elsif @user.update_attributes(params[:user])
      redirect_to log_in_url, :notice => t("session.password_reset")
    else
      render :edit
    end
  end
end

