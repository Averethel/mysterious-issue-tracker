source 'https://rubygems.org'

gem 'rails', '~> 4.2.4'
gem 'rails-api'
gem 'pg'

gem 'active_model_serializers', git: 'https://github.com/rails-api/active_model_serializers.git'
gem 'unicorn'

gem 'kaminari'

gem 'bcrypt'
gem 'pundit'

group :development do
  gem 'spring'
  gem 'thin'

  gem 'guard-rspec', require: false
end

group :development, :test do
  gem 'byebug'
  gem 'shoulda-matchers'
  gem 'rspec-rails'
end

group :test do
  gem 'factory_girl_rails'
end

ruby "2.2.3"
