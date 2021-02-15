source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '2.7.1'

gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'active_model_serializers'
gem 'rack-cors'
gem 'date_validator'
gem 'bullet'
gem 'whenever', require: false
gem 'aws-sdk-s3', require: false
gem 'fcm'
gem 'firebase-auth-id_token_keeper'

gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'factory_bot_rails'
  gem 'webdrivers'
  gem 'launchy'
  gem 'shoulda-matchers',
  git: 'https://github.com/thoughtbot/shoulda-matchers.git'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
