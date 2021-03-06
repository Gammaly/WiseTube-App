# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'
describe 'Test CreateNewLink Service Objects' do
  before do
    @credentials = { username: 'soumya.ray', password: 'mypa$$w0rd' }
    @playlist_id = 1
    @link_data = { title: 'SEC', description: 'I love SEC', url: 'https://www.youtube.com/watch?v=HsonXuJs8-s' }
  end

  after do
    WebMock.reset!
  end

  describe 'Link Creation' do
    it 'HAPPY: should be able to create new link into a playlist for an accounts' do
      # auth
      auth_account_file = 'spec/fixtures/auth_account.json'
      auth_return_json = File.read(auth_account_file)

      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: SignedMessage.sign(@credentials).to_json)
             .to_return(body: auth_return_json,
                        headers: { 'content-type' => 'application/json' })

      auth_os = JSON.parse(WiseTube::AuthenticateAccount.new.call(**@credentials).to_json, object_class: OpenStruct)

      # link
      create_link_file = 'spec/fixtures/create_link.json'
      create_return_json = File.read(create_link_file)

      WebMock.stub_request(:post, "#{API_URL}/playlists/#{@playlist_id}/links")
             .with(body: @link_data.to_json)
             .to_return(status: 201, body: create_return_json,
                        headers: { 'content-type' => 'application/json' })

      link_created = WiseTube::CreateNewLink.new(APP_CONFIG).call(current_account: auth_os,
                                                                  playlist_id: @playlist_id,
                                                                  link_data: @link_data)
      link_created = link_created['data']['attributes']
      _(link_created).wont_be_nil
      _(link_created['title']).must_equal @link_data[:title]
      _(link_created['description']).must_equal @link_data[:description]
      _(link_created['url']).must_equal @link_data[:url]
    end
  end
end
