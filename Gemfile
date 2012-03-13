source 'http://rubygems.org'

gem 'rails', '3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# XML/HTML parsing system
gem "nokogiri"

# Login System
gem "authlogic"

# Email for errors 
gem "exception_notification"

#Screen Shot Gem I know some one build this That means I don't have to work on creating it.
# Oh one more thing using this requires a bit of understading. Pulling the css information
gem "imgkit"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'


platforms :mswin do
  # I know you use windows so for all the gems you need for windows put them here
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :production do
  gem "pg"
end

group :development do
  gem 'sqlite3'
end

group :test do
  # Pretty printed test output
  gem 'turn', '0.8.2', :require => false
end
