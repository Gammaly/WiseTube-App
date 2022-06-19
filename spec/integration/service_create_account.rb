# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Service Objects' do
  before do
    @credentials = { email: 'sray@gmail.com', username: 'soumya.ray', password: 'mypa$$w0rd' }
    @mal_credentials = { username: 'soumya.ray', password: 'wrongpassword' }
    @api_account = { username: 'soumya.ray', email: 'sray@nthu.edu.tw' }
  end

  after do
    WebMock.reset!
  end

  describe 'Account Creation' do
    it 'HAPPY: should be able to create new accounts' do
      create_account_file = 'spec/fixtures/create_account.json'
      create_return_json = File.read(create_account_file)

      WebMock.stub_request(:post, "#{API_URL}/accounts")
             .with(body: SignedMessage.sign(@credentials).to_json)
             .to_return(body: create_return_json,
                        headers: { 'content-type' => 'application/json' })

      auth = WiseTube::CreateAccount.new.call(**@credentials)

      account = auth[:account]['attributes']
      _(account).wont_be_nil
      _(account['username']).must_equal @api_account[:username]
      _(account['email']).must_equal @api_account[:email]
    end

    it 'BAD AUTHENTICATION: should not find a false authenticated account' do
      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: SignedMessage.sign(@mal_credentials).to_json)
             .to_return(status: 401)
      _(proc {
        WiseTube::AuthenticateAccount.new.call(**@mal_credentials)
      }).must_raise WiseTube::AuthenticateAccount::NotAuthenticatedError
    end
  end
end
