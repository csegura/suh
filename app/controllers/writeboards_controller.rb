class WriteboardsController < ApplicationController
  include Security
  respond_to :html, :js

  before_filter :login_required
  before_filter :load_writeboard, :only => [:show, :destroy, :edit]

  def index
    load_writeboards
    respond_with(@writeboards)
  end

  def show
  end

  def version
    load_writeboard_version_number(params[:writeboard_id], params[:id])
    render :show
  end

  def edit
  end

  def update
    @writeboard = Writeboard.find(params[:id])
    check_access_for @writeboard

    if @writeboard.update_attributes(params[:writeboard])
      flash[:notice] = t('writeboard.updated')
      redirect_to writeboard_path(@writeboard)
    else
      Rails.logger.info @writeboard.errors.messages
      render :edit
    end
  end

  def new
    @writeboard = Writeboard.new
  end

  def create
    @writeboard = Writeboard.create_new_writeboard current_user_company, current_access, params[:writeboard]

    if @writeboard.save
      flash[:notice] = t('writeboard.added')
      respond_with @writeboard, :location => writeboards_path
    else
      Rails.logger.info @writeboard.errors.messages
      render :new
    end
  end

  private

  def load_writeboards
    @writeboards = load_by_access Writeboard
    @writeboards = @writeboards.last_versions

    @writeboards = @writeboards.for_company_in_main_company(current_company, params[:company]) if filter :company

    @writeboards = @writeboards.paginate :page => params[:page],
                                         :per_page => Writeboard.per_page
  end


  def load_writeboard(id=params[:id])
    @writeboard = Writeboard.find(id)
    check_access_for @writeboard
    @current_version = @writeboard
    @versions = @writeboard.versions

    @current_version_number = @writeboard.last_version
  end

  def load_writeboard_version_number(writeboard_id, version_number)
    load_writeboard(writeboard_id)
    @current_version = @writeboard.get_version(version_number)
    @current_version_number = version_number.to_i
  end
end