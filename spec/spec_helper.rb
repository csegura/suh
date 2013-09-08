# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

#require File.dirname(__FILE__) + "/factories"
require 'shoulda'
require 'capybara/rspec'

require 'i18n/backend'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # rspec/support
  config.include(MailerMacros)
  config.before(:each) { reset_email }
end

I18n.backend.load_translations
Capybara.app_host = "http://www.test.com"

def t(*args)
  I18n.t(*args)
end

def route_matches(path, method, params)
  it "is routable for params #{params.inspect} with #{method.to_s.upcase} and #{path.inspect}" do
    {method.to_sym => path}.should route_to(params)
  end
end

# UserMailer.should deliver(:send_invitation).with(user.id)
RSpec::Matchers.define :deliver do |message|
  chain :with do |*args|
    @with = args
  end

  match do |mailer|
    mail = double
    mail.should_receive(:deliver)
    mailer.should_receive(message).with(*@with).and_return(mail)
  end
end

def switch_to_subdomain(subdomain)
  host = Capybara.app_host
  Capybara.app_host = "http://#{subdomain}.test.com"
  yield
  Capybara.app_host = host
end
