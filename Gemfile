# frozen_string_literal: true

source "https://rubygems.org"
ruby RUBY_VERSION

gem "rake"

group :development do
  gem "pry", :require => false

  # RSpec formatter
  gem "fuubar", :require => false

  platform :mri do
    gem "pry-byebug"
  end
end

group :test do
  gem "certificate_authority", "~> 1.0", :require => false

  gem "backports"

  gem "rubocop", "~> 1.55.0"
  gem "rubocop-performance"
  gem "rubocop-rake"
  gem "rubocop-rspec"

  gem "simplecov",      :require => false
  gem "simplecov-lcov", :require => false

  gem "rspec", "~> 3.10"
  gem "webmock", "~> 3.18"

  gem "yardstick"
end

group :doc do
  gem "kramdown"
  gem "yard"
end

# Specify your gem's dependencies in http.gemspec
gemspec
