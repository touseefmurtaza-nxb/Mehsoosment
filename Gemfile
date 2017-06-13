source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end
ruby '2.2.6'
gem 'rails', '~> 5.0.2'
# Postgresql database
gem 'pg'
# Puma app server
gem 'puma', '~> 3.0'
# Json Customization
gem 'jbuilder', '~> 2.5'
# Sms alert service
gem 'twilio-ruby', '~> 4.1.0'
# Near by locations by google
gem 'geocoder'
gem 'geokit-rails'
gem 'polylines'
# Push notifications for iOS
gem 'pushmeup'
# Push notifications for android
gem 'fcm'
# Get exception occurance email
# gem 'exception_notification'
# Api's Documentations
gem 'apipie-rails'
# Image upload
gem 'paperclip', "~> 5.0.0"
# Secure Password
gem 'bcrypt', '~> 3.1.7'
# Token Base Authentication
gem 'jwt'
# instead of facilitating the connection between the controller and the view, it does the same for the controller and the model
gem 'simple_command'

group :development, :test do
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'byebug', platform: :mri
end

group :test do
  gem 'shoulda-matchers', '~> 3.1'
  gem 'faker'
  gem 'database_cleaner'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Debugging tools
  gem 'pry-rails'
  # gem 'letter_opener'
  gem 'annotate'
  # Deployment gems
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails', '~> 1.1.2'
  gem 'capistrano-rbenv', '~> 2.0.2'
  gem 'capistrano-bundler', '~> 1.1.3'

end
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
