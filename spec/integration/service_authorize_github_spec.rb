# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Service Objects' do
  before do
    @credentials = { username: 'soumya.ray', password: 'mypa$$w0rd' }
    @code = 123
    @api_account = { username: 'soumya.ray', email: 'sray@nthu.edu.tw' }
  end

  after do
    WebMock.reset!
  end

  describe 'Authorize Github Account' do
    it 'HAPPY: should authorize Github account' do
      auth_account_file = 'spec/fixtures/auth_account.json'

      auth_return_json = File.read(auth_account_file)

      WebMock.stub_request(:post, "https://github.com/login/oauth/access_token")
             .with(body: {"client_id"=>"46373e75bcc1d9ff0f93", "client_secret"=>"efc18a3fb7af94a9e0d18f1fda2a1198c17ce9f2", "code"=>"123"})
             .to_return(body: auth_return_json,
                        headers: { 'content-type' => 'application/json' })

      WebMock.stub_request(:post, "http://localhost:3000/api/v1/auth/gh_sso").
      with(
        body: "{\"data\":{\"access_token\":null},\"signature\":\"VK4CYnrR0kHGM0ipDVabA2VUx/zx9kKis8XKZP0wR3fVH8tkQy1ZiZaMi9dmAkrDmhOaVNzbBKa20g9pgHMkDA==\"}",
        headers: {
        'Connection'=>'close',
        'Content-Type'=>'application/json; charset=UTF-8',
        'Host'=>'localhost:3000',
        'User-Agent'=>'http.rb/5.0.4'
        }).
      to_return(status: 200, body: auth_return_json, headers: {})

      authorized = WiseTube::AuthorizeGithubAccount.new(APP_CONFIG).call(@code)

      authorized = authorized[:account]['attributes']
      _(authorized).wont_be_nil
      _(authorized['username']).must_equal @api_account[:username]
      _(authorized['email']).must_equal @api_account[:email]
    end
  end
end
