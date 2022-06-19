# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'
describe 'Test GetLink Service Objects' do
  before do
    @credentials = { username: 'soumya.ray', password: 'mypa$$w0rd' }
    @link_id = 'f91a942a-6371-4e36-bfb4-bc1c54f535e8'
    @api_link = { title: '國立清華大學 服務科學研究所', description: 'ISS NTHU Website' }
  end

  after do
    WebMock.reset!
  end

  describe 'Get One Link' do
    it 'HAPPY: should be able to get the link belonging to an playlist' do
      # auth
      auth_account_file = 'spec/fixtures/auth_account.json'
      auth_return_json = File.read(auth_account_file)

      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: SignedMessage.sign(@credentials).to_json)
             .to_return(body: auth_return_json,
                        headers: { 'content-type' => 'application/json' })

      auth_os = JSON.parse(WiseTube::AuthenticateAccount.new.call(**@credentials).to_json, object_class: OpenStruct)

      # playlist
      get_link_file = 'spec/fixtures/get_link.json'
      get_link_return_json = File.read(get_link_file)

      WebMock.stub_request(:get, "#{API_URL}/links/#{@link_id}")
             .with(headers: { 'Authorization' => "Bearer #{auth_os.auth_token}" })
             .to_return(status: 200, body: get_link_return_json, headers: { 'content-type' => 'application/json' })

      link = WiseTube::GetLink.new(APP_CONFIG).call(auth_os, @link_id)
      link = link['attributes']

      _(link).wont_be_nil
      _(link['title']).must_equal @api_link[:title]
      _(link['description']).must_equal @api_link[:description]
    end
  end
end
