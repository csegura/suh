class Admin::AccessesController < ApplicationController
  respond_to :html, :js

  before_filter :login_required,
                :load_company

  before_filter :load_access, :only => [:edit, :update, :destroy]

  def new
    Rails.logger.debug "Acceses controller new"
    Rails.logger.debug "@company is nil" if @company.nil?
    Rails.logger.debug "++ company " + @company.inspect

    @access = @company.accesses.new
    @access.build_user

    Rails.logger.debug "@access is nil" if @access.nil?
    Rails.logger.debug "++ access " + @access.inspect
  rescue Exception => e
    Rails.logger.debug e

  end

  def edit
  end

  def create
    @access = Access.new(params[:access])
    @access.company = @company
    if @access.save
      flash[:notice] = t('access.added')
      respond_with @access, :location => admin_path
    else
      Rails.logger.info @access.errors.messages
      render :new
    end
  end

  def update
    if @access.update_attributes(params[:access])
      flash[:notice] = t('access.updated')
      respond_with @access, :location => admin_path
    else
      Rails.logger.info @access.errors.messages
      render :edit
    end
  end

  def activation
    @access = Access.find(params[:access_id])
    @access.update_attribute(:active, @access.active? ? false : true)
  end

  def resend_invitation
    @access = Access.find(params[:access_id])
    @access.user.send_invitation(@access.invitation,@access.company)
  end

  def destroy
    @access.destroy
    redirect_to admin_path
  end

  private

  def load_company
    @company = Company.find(params[:company_id])
  end

  def load_access
    @access = Access.find(params[:id])
  end

end