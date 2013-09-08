class AdminController < ApplicationController
  respond_to :html, :js

  before_filter :login_required

  def show
    @companies = current_company.companies
  end

end