class HomeController < ApplicationController
  before_filter :login_required, :except => :index

  def index
    render :layout => "home_web"
  end

  def sample
  end

  def sample2
  end

  def sample3
    render :layout => "application_min"
  end

  def full
    render :layout => "application_full"
  end
end
