class Admin::CompaniesController < ApplicationController
  respond_to :html, :js
  before_filter :login_required

  # GET /companies/new
  # GET /companies/new.json
  def new
    @company = current_company.companies.build
    @company.build_avatar
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
    @company.build_avatar if @company.avatar.nil?
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = current_company.companies.build(params[:company])

    if @company.save
      #redirect_to admin_path, :notice => t('company.created')
      respond_with @company, :location => admin_path
    else
      render :new
    end
  end

  # PUT /companies/1
  # PUT /companies/1.json
  def update
    @company = Company.find(params[:id])

    if @company.update_attributes(params[:company])
      flash[:notice] = t('company.updated')
      respond_with @company, :location => admin_path
    else
      render :edit
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to admin_accesses_path }
      format.json { head :ok }
    end
  end
end
