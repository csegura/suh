class Me::ProfileController < ApplicationController
  layout "me"
  respond_to :html, :js

  before_filter :login_required

  # GET /me/profile/edit
  def edit
    @profile = current_user.user_profile || current_user.create_user_profile
  end

  # POST /me/profile
  def update
    @profile = current_user.user_profile
    if @profile.update_attributes(params[:user_profile])
      redirect_to :me, :notice => t('user_profile.updated')
    else
      Rails.logger.info @profile.errors.inspect
      render :edit
    end
  end

end