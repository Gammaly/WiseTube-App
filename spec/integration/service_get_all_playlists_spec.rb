# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'
describe 'Test GetAllPlaylists Service Objects' do
  before do
    @credentials = { username: 'soumya.ray', password: 'mypa$$w0rd' }
    @api_playlist = { name: 'Lofi Music', playlist_url: 'https://www.youtube.com/playlist?list=PLADsQ5aecQedTX6h-NqFDMjaLtNopVYv_' }
  end

  after do
    WebMock.reset!
  end

  describe 'Get all Playlists' do
    it 'HAPPY: should be able to get all playlists belonging to an account' do
      # auth
      auth_account_file = 'spec/fixtures/auth_account.json'
      auth_return_json = File.read(auth_account_file)

      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: SignedMessage.sign(@credentials).to_json)
             .to_return(body: auth_return_json,
                        headers: { 'content-type' => 'application/json' })

      auth_os = JSON.parse(WiseTube::AuthenticateAccount.new.call(**@credentials).to_json, object_class: OpenStruct)

      # playlist
      get_playlists_file = 'spec/fixtures/get_all_playlists.json'
      get_playlists_return_json = File.read(get_playlists_file)

      WebMock.stub_request(:get, "#{API_URL}/playlists")
             .to_return(status: 200, body: get_playlists_return_json,
                        headers: { 'content-type' => 'application/json' })

      playlists_list = WiseTube::GetAllPlaylists.new(APP_CONFIG).call(auth_os)

      _(playlists_list).wont_be_nil
      _(playlists_list[0]['attributes']['name']).must_equal @api_playlist[:name]
      _(playlists_list[0]['attributes']['playlist_url']).must_equal @api_playlist[:playlist_url]
    end
  end
end
