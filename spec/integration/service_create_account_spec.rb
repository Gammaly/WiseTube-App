# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'
describe 'Test CreateAccount Service Objects' do
  before do
    @credentials = { email: 'gammaly@gmail.com', username: 'gammaly', password: 'mypa$$w0rd' }
    # @mal_credentials = { username: 'soumya.ray', password: 'wrongpassword' }
    @api_account = { username: 'gammaly', email: 'gammaly@gmail.com' }
  end

  after do
    WebMock.reset!
  end

  describe 'Account Creation' do
    it 'HAPPY: should be able to create new accounts' do
      create_account_file = 'spec/fixtures/create_account.json'
      create_return_json = File.read(create_account_file)

      WebMock.stub_request(:post, "#{API_URL}/accounts/")
             .with(body: SignedMessage.sign(@credentials).to_json)
             .to_return(status: 201, body: create_return_json,
                        headers: { 'content-type' => 'application/json' })

      account_created = WiseTube::CreateAccount.new(APP_CONFIG).call(**@credentials)

      _(account_created).wont_be_nil
      _(account_created[:username]).must_equal @api_account[:username]
      _(account_created[:email]).must_equal @api_account[:email]
    end
  end
end
