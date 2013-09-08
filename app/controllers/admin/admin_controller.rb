class Admin::AccessesController < ApplicationController
  respond_to :html, :js

  before_filter :login_required

  def index
    @companies = current_company.companies
  end

  #def new
  #end

end