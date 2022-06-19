# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'
describe 'Test GetPlaylist Service Objects' do
  before do
    @credentials = { username: 'soumya.ray', password: 'mypa$$w0rd' }
    @playlist_id = 1
    @api_playlist = { name: 'Lofi Music', playlist_url: 'https://www.youtube.com/playlist?list=PLADsQ5aecQedTX6h-NqFDMjaLtNopVYv_' }
  end

  after do
    WebMock.reset!
  end

  describe 'Get One Playlist' do
    it 'HAPPY: should be able to get the playlists belonging to an account' do
      # auth
      auth_account_file = 'spec/fixtures/auth_account.json'
      auth_return_json = File.read(auth_account_file)

      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: SignedMessage.sign(@credentials).to_json)
             .to_return(body: auth_return_json,
                        headers: { 'content-type' => 'application/json' })

      auth_os = JSON.parse(WiseTube::AuthenticateAccount.new.call(**@credentials).to_json, object_class: OpenStruct)

      # playlist
      get_playlist_file = 'spec/fixtures/get_playlist.json'
      get_playlist_return_json = File.read(get_playlist_file)

      WebMock.stub_request(:get, "#{API_URL}/playlists/#{@playlist_id}")
             .to_return(status: 200, body: get_playlist_return_json,
                        headers: { 'content-type' => 'application/json' })

      playlists_list = WiseTube::GetPlaylist.new(APP_CONFIG).call(auth_os, @playlist_id)
      playlists_list = playlists_list['attributes']

      _(playlists_list).wont_be_nil
      _(playlists_list['name']).must_equal @api_playlist[:name]
      _(playlists_list['playlist_url']).must_equal @api_playlist[:playlist_url]
    end
  end
end
