source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

gem 'rails', '6.0.2.2'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma'
gem 'webpacker'
gem 'kaminari'
gem 'bcrypt'
gem 'knock'
gem 'rack-cors'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'sucker_punch'
gem 'aws-sdk-s3'
gem 'shrine'
gem 'image_processing'
gem 'searchkick'
gem 'typhoeus'
gem 'oj'

# Add sentry-raven

group :development, :test do
  gem 'pry-rails'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
