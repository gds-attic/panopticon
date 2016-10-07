require_relative 'test_helper'
require_relative 'helpers/artefact_need_ids_form_filler'
require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include ArtefactNeedIdsFormFiller

  setup do
    stub_request(:patch, %r[http://publishing-api.dev.gov.uk/v2/links/*]).to_return(body: {}.to_json)
  end

  teardown do
    Capybara.use_default_driver
  end

  def post_json(path, attrs, headers = {})
    post path, attrs.to_json, {"Content-Type" => "application/json", "Accept" => "application/json", "Authorization" => "Bearer foo"}.merge(headers)
  end

  def put_json(path, attrs, headers = {})
    put path, attrs.to_json, {"Content-Type" => "application/json", "Accept" => "application/json", "Authorization" => "Bearer foo"}.merge(headers)
  end

  def login_as(user)
    GDS::SSO.test_user = user
  end

  def login_as_user_with_permission(permission)
    user = create(:user, permissions: ['signin', permission])
    login_as(user)
  end

end
