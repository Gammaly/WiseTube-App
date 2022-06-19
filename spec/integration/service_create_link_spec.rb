# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'
describe 'Test CreateNewPlaylist Service Objects' do
  before do
    @playlist_data = { name: 'Demo', playlist_url: 'https://www.youtube.com/watch?v=12' }
    @credentials = { username: 'soumya.ray', password: 'mypa$$w0rd' }

    # @mal_credentials = { username: 'soumya.ray', password: 'wrongpassword' }
    @api_account = { name: 'dfgh', playlist_url: 'https://www.youtube.com/watch?v=12Hzlhpb21I&list=RDCMUC7IcJI8PUf5Z3zKxnZvTBog&start_radio=1dfgh' }
  end

  after do
    WebMock.reset!
  end

  describe 'Playlist Creation' do
    it 'HAPPY: should be able to create new playlist for an accounts' do
      auth_account_file = 'spec/fixtures/auth_account.json'
      auth_return_json = File.read(auth_account_file)

      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: SignedMessage.sign(@credentials).to_json)
             .to_return(body: auth_return_json,
                        headers: { 'content-type' => 'application/json' })

      auth_os = JSON.parse(WiseTube::AuthenticateAccount.new.call(**@credentials).to_json, object_class: OpenStruct)

      create_playlist_file = 'spec/fixtures/create_playlist.json'
      create_return_json = File.read(create_playlist_file)

      WebMock.stub_request(:post, "#{API_URL}/playlists")
             .with(body: @playlist_data.to_json)
             .to_return(status: 201, body: create_return_json,
                        headers: { 'content-type' => 'application/json' })

      playlist_created = WiseTube::CreateNewPlaylist.new(APP_CONFIG)
                                                    .call(current_account: auth_os, playlist_data: @playlist_data)
      playlist_created = playlist_created['data']['attributes']

      _(playlist_created).wont_be_nil
      _(playlist_created['name']).must_equal @api_account[:name]
      _(playlist_created['playlist_url']).must_equal @api_account[:playlist_url]
    end

    # it 'BAD AUTHENTICATION: should not find a false authenticated account' do
    #   WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
    #          .with(body: SignedMessage.sign(@mal_credentials).to_json)
    #          .to_return(status: 401)
    #   _(proc {
    #     WiseTube::AuthenticateAccount.new.call(**@mal_credentials)
    #   }).must_raise WiseTube::AuthenticateAccount::NotAuthenticatedError
    # end
  end
end
