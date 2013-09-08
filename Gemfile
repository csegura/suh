source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', " ~> 3.1.0"
  gem 'coffee-rails', " ~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'sqlite3', :group => :development

# gem "remotipart", "~> 1.0"
# Use unicorn as the web server
# gem 'unicorn'


# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

#gem 'simple_form'                   # awesome form
gem "squeel" # search
gem 'active_device' # mobile
gem 'simple_form' # , :path => "~/code/fork/simple_form"
gem 'will_paginate', '~> 3.0'
gem 'cocoon'                        # nested forms
gem 'paperclip'                     # attach files
gem 'gravatar_image_tag'            # avatars
gem 'hpricot'                       # required for premailer
gem 'premailer-rails3'              # html emails
gem 'acts_as_role'
gem 'acts_as_versionable'
gem 'sortifiable'



group :development do
  #gem 'annotate'
  gem 'annotate', :git => 'git://github.com/jeremyolliver/annotate_models.git', :branch => 'rake_compatibility'
  gem 'yaml_db' # backup database to yaml

  # Deploy with Capistrano
  gem 'capistrano'
end

group :test do
  gem 'rspec-rails'
  gem 'fuubar' # rspec bar formater
  gem 'factory_girl_rails'
  gem 'shoulda'
  gem 'shoulda-matchers' # better matchers
  gem 'capybara'
end

group :production do
  gem 'mysql2'
  gem 'rake'
end