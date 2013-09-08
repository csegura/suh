class DashboardController < ApplicationController
  include Security
  respond_to :html, :js, :json
  before_filter :login_required

  def index
    load_activities
    @activities = @activities.paginate :page => params[:page],
                                       :per_page => Activity.per_page

    respond_with(@activities)
  end

  def unread_count
    activities = Activity.load_activities current_access
    @unread_counter = activities.unread(current_user).count
    respond_with @unread_counter, :layout => false
  end

  def read_all
    activities = Activity.load_activities current_access
    activities = activities.unread(current_user)
    activities.each do |activity|
      activity.mark_read(current_user)
    end
    redirect_to :index
  end

  def calendar
    load_activities
    if request.xhr?
      render :text => events_json
    end
  end

  def calendar_data
    load_activities
    render :text => events_json
  end

  def load_activities

    #@activities = Activity.load_activities current_access

    #if (not params[:activity].nil?) && params[:activity] != "all"
    #  @activities = @activities.for_activity(params[:activity].classify)
    #end

    if filter(:company) && is_owner?
      #@activities = Activity.for_company_id(params[:company])
      Rails.logger.info params.inspect
      @activities = Activity.for_company_in_main_company(current_company, params[:company])
    else
      @activities = Activity.load_activities current_access
    end

    @activities = @activities.for_activity(params[:activity].classify) if filter :activity
    @activities = @activities.for_month(Date.parse(params[:month])) if filter :month

    if filter(:read)
      if filter_value_enabled(:read)
        @activities = @activities.read(current_user)
      else
        @activities = @activities.unread(current_user)
      end
    end

    @activities_months = @activities.get_months
  end

  def events_json
    events = []
    @activities.each do |event|
      events << {
          :id => event.id,
          :title => event.subject_type,
          :description => event.info || "na",
          :start => "#{event.created_at.iso8601}",
          :end => "#{event.created_at.iso8601}",
          :allDay => false,
          :recurring => false}
    end
    events.to_json
  end

end