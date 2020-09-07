source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2'
gem 'dotenv-deployment'
gem 'dotenv-rails'

# App required gems
gem 'qa'
gem 'gruff', github: 'elrayle/gruff', branch: 'hide_labels_separate_from_lines'

# Other gems
gem 'coffee-rails', '~> 4.2'
gem 'concurrent-ruby'
gem 'jbuilder', '~> 2.5'
gem 'lograge'
gem 'pg'
gem 'puma', '~> 4.3'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'uglifier', '>= 1.3.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
# Access an interactive console on exception pages or by calling 'console' anywhere in the code.
gem 'listen', '>= 3.0.5', '< 3.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 4.4', require: false
  gem 'faker'
  gem 'webmock'
end

group :development do
  gem 'better_errors' # provide debugging command line in
  gem 'binding_of_caller' # provides deep stack info used by better_errors
  gem 'bixby', '~> 1.0.0' # rubocop styleguide
  gem 'rubocop'
  gem 'rubocop-checkstyle_formatter', require: false
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring' # Spring speeds up development by keeping your application running in the background.
  # gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'simplecov'
  gem 'web-console', '~> 3.0' # access to IRB console on exception pages
  gem 'xray-rails' # provides a dev bar and an overlay in-browser to visualize your UI's rendered partials
end

group :test do
  # # Adds support for Capybara system testing and selenium driver
  # gem 'capybara', '>= 2.15'
  # gem 'selenium-webdriver'
  # # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper'
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'rspec-its', '~> 1.1'
  gem 'rspec-rails', '~> 3.1'
  gem 'sqlite3'
end
