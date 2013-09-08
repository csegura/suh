class IssuesController < ApplicationController
  include Security
  respond_to :html, :js

  before_filter :login_required
  before_filter :load_issue, :only => [:show, :destroy, :close, :reopen]

  def index
    load_issues
    respond_with(@issues)
  end

  def show
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.create_new_issue current_user_company, current_access, params[:issue]

    if @issue.save
      flash[:notice] = t('issue.added')
      respond_with @issue, :location => issues_path
    else
      Rails.logger.info @issue.errors.messages
      render :new
    end
  end

  def close
    @issue.close current_user
  end

  def reopen
    @issue.reopen current_access
  end

  private

  def load_issues
    @issues = load_by_access Issue
    @issues_months = @issues.get_months

    @issues = @issues.for_status(params[:status]) if filter :status
    @issues = @issues.for_month(Date.parse(params[:month])) if filter :month
    @issues = @issues.for_company_in_main_company(current_company,params[:company]) if filter :company

    @issues = @issues.paginate :page => params[:page],
                               :per_page => Issue.per_page
  end

  def load_issue
    Rails.logger.info "** init"
    @issue = Issue.find(params[:id], :include => [:comments])
    check_access_for @issue

    @comments = params[:trash] ? @issue.comments : @issue.comments.not_in_trash
    @comments_count = @comments.count
    @comments_in_trash_count = @issue.comments.in_trash.count

    @timetracks = params[:trash] ? @issue.timetracks : @issue.timetracks.not_in_trash
    @timetracks_count = @timetracks.count
    @timetracks_in_trash_count = @issue.timetracks.in_trash.count

    Rails.logger.info "*****"

  end
end