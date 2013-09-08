require 'spec_helper'

describe Login::SessionsController do

  route_matches("/login/in", :get,  :controller => "login/sessions", :action => "new")
  route_matches("/login/in", :post, :controller => "login/sessions", :action => "create")
  route_matches("/login/out",:get,  :controller => "login/sessions", :action => "destroy")

  describe "basic log_in" do
    it "should index login screen" do
      @request.host = "www.test.com"
      get :new
      response.should render_template("sessions/new")
    end

    it "should redirect to main page if subdomain not exist" do
      @request.host = "dont_exist.test.com"
      get :new
      response.should redirect_to(::AppConfig.main_web)
    end

    describe "in a company domain" do
      before(:each) do
        @main_company = Factory(:main_company)
        @request.host = "#{@main_company.subdomain}.test.com"
      end
      it "should index login screen" do
        get :new
        response.should render_template("sessions/new")
      end
    end

  end
end