class TimetracksController < ApplicationController
  include Security
  respond_to :html, :js

  #  GET  /timetracks/:id(.:format)

  def index
    load_timetracks
    respond_with(@timetracks)
  end

  def show
    load_timetrack
  rescue
    flash[:alert] = t('timetrack.not_found')
    redirect_to :back
  end

  # document_comments POST   /documents/:document_id/comments(.:format)
  # issue_comments POST   /issues/:issue_id/comments(.:format)
  def create
    @trackable = find_trackable
    @timetrack = @trackable.timetracks.build(params[:timetrack]) do |timetrack|
      timetrack.access = current_access
    end
    if @timetrack.save
      flash.now[:notice] = t('timetrack.added')
      Rails.logger.info @timetrack.inspect
      @counter = @trackable.timetracks.count
      respond_with @timetrack
    else
      Rails.logger.info @timetrack.errors.messages
      flash.now[:error] = t('timetrack.added.error')
    end
  end

  def destroy
    load_timetrack
    @timetrack.move_to_trash
    @trackable = @timetrack.trackable
    @counter = @trackable.timetracks.not_in_trash.count
  end

  def confirm
    load_timetrack
    @timetrack.confirm current_access
  end

  private

  def load_timetracks
      @timetracks = load_by_access Timetrack
      @timetracks_months = @timetracks.get_months

      @timetracks = @timetracks.for_status(params[:status]) if filter :status
      @timetracks = @timetracks.for_month(Date.parse(params[:month])) if filter :month
      @timetracks = @timetracks.for_company_in_main_company(current_company,params[:company]) if filter :company

      @timetracks = @timetracks.paginate :page => params[:page],
                                 :per_page => Timetrack.per_page
  end

  def load_timetrack
    @timetrack = Timetrack.find(params[:id])
    check_access_for @timetrack
  end

  # finds a matching parameter it calls classify on the part of the name
  # before the _id to turn in it from a table name in to a model name
  def find_trackable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end

end