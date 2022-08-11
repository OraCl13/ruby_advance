require 'rails_helper'
require 'capybara/email/rspec'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit

  config.include AcceptanceMacros, type: :feature

  config.use_transactional_fixtures = false

  Capybara.default_host = 'http://localhost:3000'

  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = {
    provider: 'facebook',
    uid: '123545',
    info:
      { email: 'infinite@jest.com',
        first_name: 'TEST',
        last_name: 'TEST' }
  }

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end