source 'https://rubygems.org'
ruby "2.0.0"

gem 'rails', '~> 3.2.13'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'haml'
gem 'bootstrap-sass'
gem 'sanitize'
gem 'jquery-tools'
gem 'open_uri_redirections'
gem 'bcrypt-ruby'

group :development do
  gem 'sqlite3'
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'pry-doc'
end

group :production do
  gem 'pg'
end

group :test do
  gem 'simplecov', require: false
  gem 'selenium-webdriver'
  gem 'capybara', "~> 2.1.0.beta1"
  gem 'factory_girl_rails'
  gem 'guard-cucumber'
  gem 'database_cleaner'
  gem 'cucumber-rails', :require => false
  gem 'rb-inotify', '~> 0.9'
  gem 'libnotify', '0.8.0'
end

group :development, :test do
  gem 'guard-spork'
  gem 'spork-rails'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'jasmine'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'therubyracer'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
