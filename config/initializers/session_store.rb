# Be sure to restart your server when you modify this file.

Suh::Application.config.session_store :cookie_store, :key => '_suh_session', :domain => :all, :tld_length => 2
                                      # :domain => ".#{::AppConfig.domain_name}"

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Suh::Application.config.session_store :active_record_store
