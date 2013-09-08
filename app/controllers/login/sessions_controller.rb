class Login::SessionsController < ApplicationController
  layout "login"

  # GET /login/in
  def new
    if request.subdomain != ::AppConfig.main_subdomain
      company = Company.find_by_subdomain(request.subdomain)
      if company.nil?
        redirect_to ::AppConfig.main_web
      else
        @name = company.name
      end
    else
      @name = ::AppConfig.app_name
    end
  end

  # POST /login/in
  def create
    user = User.find_by_email(params[:email])
    if user && user.active? && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = { :value => user.auth_token, :domain => ::AppConfig.domain_name }
        #cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = { :value => user.auth_token, :domain => ::AppConfig.domain_name }
        #cookies[:auth_token] = user.auth_token
      end
      user.update_last_login request.ip
      Rails.logger.info ">> trying request #{session[:return_to]}"
      redirect_to session[:return_to] || root_url
    else
      flash.now.alert = t("session.invalid_login")
      render :new
    end
  end

  # GET /login/out
  def destroy
    cookies[:auth_token] = { :value => nil, :domain => ::AppConfig.domain_name }
    #cookies.delete(:auth_token)
    #cookies[:auth_token] = { :value => nil, :}
    redirect_to root_url
  end
end
