class ActivitiesController < ApplicationController
  include Security
  respond_to :js

  def read
    @activity = Activity.find(params[:activity_id])
    @activity.mark_read(current_user.id)
  end

  def unread
    @activity = Activity.find(params[:activity_id])
    @activity.mark_unread(current_user.id)
  end

end