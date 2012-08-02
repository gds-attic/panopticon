require 'test_helper'
require 'capybara/rails'
require 'capybara/mechanize'
require 'webmock'

DatabaseCleaner.strategy = :truncation

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include WebMock::API

  def setup
    DatabaseCleaner.clean

    WebMock.allow_net_connect!
    stub_request(:get, /assets\.test\.gov\.uk/).to_return(status: 404)

    @server = startup_server
  end

  def teardown
    DatabaseCleaner.clean
    WebMock.reset!  # Not entirely sure whether this happens anyway
  end

  def startup_server
    server = Capybara::Server.new(Capybara.app)
    server.boot
    server
  end

  def create_test_user
    FactoryGirl.create(:user, name: "Test", email: "test@example.com", uid: 123)
  end
end

Capybara.app = Rack::Builder.new do
  map "/" do
    run Capybara.app
  end
end

Capybara.default_driver = :mechanize