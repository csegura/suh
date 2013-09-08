class ApplicationController < ActionController::Base
  extend ActiveSupport::Memoizable
  protect_from_forgery

  include ActiveDevice

  helper_method :current_user, :current_company, :current_access, :is_owner?
  before_filter :init
  before_filter :mailer_set_url_options

  def init
    @start_time = Time.now
  end

  # To write subdomains on the url helpers:
  # root_url(nil, {:subdomain => "subdomain"})
  def url_for(options = nil)
    case options
      when Hash
        if subdomain = options.delete(:subdomain)
          if request.subdomain.empty?
            options[:host] = "#{subdomain}.#{request.host_with_port}"
          else
            options[:host] = request.host_with_port.sub(request.subdomain, subdomain)
          end
        end
    end
    super
  end

  private

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  rescue
    nil
  end

  def current_company
    @current_company ||= Company.find_by_subdomain(request.subdomain)
  end

  def current_access
    @current_access ||= Access.for_user_in_main_company(current_user, current_company)
  end

  def current_user_company
    current_access.company
  end

  # ensure that the user is logged
  # try from session & cookie
  def login_required
    Rails.logger.info ">> login_subdomain => " + request.subdomain
    Rails.logger.info ">> login_required  => " + request.fullpath

    if !is_main_subdomain? && current_company.nil?
      redirect_to ::AppConfig.main_web and return
    end

    Rails.logger.info ">> cookie found #{cookies[:auth_token]}" if cookies[:auth_token]

    unless current_user
      if request.xhr? # handle ajax session timeout
        session[:return_to] = nil
        redirect_to :log_in, :status => :forbidden and return false
      else
        session[:return_to] = request.fullpath
        redirect_to :log_in and return
      end
    end

    Rails.logger.info ">> login_required_user_email => " + current_user.email
    Rails.logger.info ">> login_required_subdomain  => " + request.subdomain
    Rails.logger.info ">> login_required_not_access " if current_access.nil?

    # user cookie without access
    if current_access.nil?
      session[:return_to] = nil
      redirect_to :log_in
    end

    #if is_main_subdomain? || current_access.nil?
    #  redirect_to :me
    #end
  end

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = ::AppConfig.main_web
    ActionMailer::Base.default_url_options[:subdomain] = request.subdomain
  end

  def filter var
    (not params[var].blank?) && (params[var] != "all")
  end

  def filter_value_enabled var
    params[var] == "yes"
  end

  def is_owner?
    current_access.is_owner?
  end

  memoize :is_owner?

  private

  def is_main_subdomain?
    request.subdomain == ::AppConfig.main_subdomain
  end

end
