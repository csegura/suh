class Me::AccountController < ApplicationController
  layout "me"
  respond_to :html, :js

  before_filter :login_required

  # GET /me/account/edit
  def edit
    @user = current_user
    @user.build_avatar if @user.avatar.nil?
  end

  # PUT /me/account
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = t('user.updated')
      respond_with @user, :location => me_path
    else
      Rails.logger.info @user.errors.inspect
      render :edit
    end
  end

end