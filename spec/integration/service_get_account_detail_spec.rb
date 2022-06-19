# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'
describe 'Test GetLink Service Objects' do
  before do
    @credentials = { username: 'soumya.ray', password: 'mypa$$w0rd' }
    @username = 'soumya.ray'
    @api_account = { username: 'soumya.ray', email: 'sray@nthu.edu.tw' }
  end

  after do
    WebMock.reset!
  end

  describe 'Get Account Detail' do
    it 'HAPPY: should be able to get the information of an account' do
      # auth
      auth_account_file = 'spec/fixtures/auth_account.json'
      auth_return_json = File.read(auth_account_file)

      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: SignedMessage.sign(@credentials).to_json)
             .to_return(body: auth_return_json,
                        headers: { 'content-type' => 'application/json' })

      auth_os = JSON.parse(WiseTube::AuthenticateAccount.new.call(**@credentials).to_json, object_class: OpenStruct)

      # account
      get_account_detail_file = 'spec/fixtures/get_account_detail.json'
      get_account_detail_return_json = File.read(get_account_detail_file)

      WebMock.stub_request(:get, "#{API_URL}/accounts/#{@username}")
             .with(headers: { 'Authorization' => "Bearer #{auth_os.auth_token}" })
             .to_return(status: 200, body: get_account_detail_return_json, headers: { 'content-type' => 'application/json' })

      account_info = GetAccountDetails.new(APP_CONFIG).call(auth_os, @username)

      _(account_info).wont_be_nil
      _(account_info.username).must_equal @api_account[:username]
      _(account_info.email).must_equal @api_account[:email]
    end
  end
end
