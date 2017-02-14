source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '~> 3.2.21'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem "compass-rails", '~> 1.0.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-fileupload-rails'
gem 'remotipart'

gem "thin", ">= 1.5.0"
gem "pg", ">= 0.15.0"
gem 'pg_search'

gem "figaro", ">= 0.6.3"
gem "sendgrid", ">= 1.0.1"

gem 'jquery-rails'
gem "haml-rails", ">= 0.4"
gem 'redcarpet'

gem 'chosen-rails'
gem 'lazybox'
gem "simple_form", "~> 2.1"

gem "devise"
gem "cancan", "~> 1.6.9"
gem "rolify", "~> 3.2.0"

gem 'draper', '~> 1.0'

gem 'state_machine'
gem 'ruby-graphviz', require: 'graphviz', group: :development

gem 'activemerchant'

# backend panel for managing schools and such
gem 'activeadmin', github: 'gregbell/active_admin', branch: '0-6-stable'
gem 'country_select'

gem 'kaminari'
gem 'default_value_for'

gem 'carrierwave'
gem 'fog', '~> 1.3.1'
gem 'mini_magick'

gem 'newrelic_rpm', group: [:production, :alpha, :staging]

gem 'mail_view', '~> 1.0.3'

group :production do
  gem 'ey_config'
end

group :alpha do
  gem 'rails_12factor'
end

group :development do
  gem 'engineyard'
  gem "html2haml", ">= 1.0.1"

  gem "guard-bundler", ">= 1.0.0"
  gem "guard-rails", ">= 0.4.0"
  gem "guard-rspec", ">= 2.5.2"
  gem "guard-brakeman"
  gem "rb-inotify", ">= 0.9.0", :require => false
  gem "rb-fsevent", ">= 0.9.3", :require => false
  gem "rb-fchange", ">= 0.0.6", :require => false

  gem "quiet_assets", ">= 1.0.2"

  gem "better_errors", ">= 0.7.2"
  gem "binding_of_caller", ">= 0.7.1", :platforms => [:mri_19, :mri_20, :rbx]

  gem 'rack-mini-profiler'
end

group :development, :test do
  gem "rspec-rails", "~> 2.14"
  gem "fabrication"
  gem "faker"
end

group :test do
  gem "capybara", ">= 2.1.0"
  gem "database_cleaner", ">= 1.0.0.RC1"
  gem "email_spec", ">= 1.4.0"
  gem 'shoulda-matchers'
  gem 'fuubar'
  gem 'poltergeist', '~> 1.4.1'
  gem 'webmock'
  gem 'vcr'
  gem 'timecop'
end
