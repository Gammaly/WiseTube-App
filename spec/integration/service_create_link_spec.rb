# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'
describe 'Test CreateNewLink Service Objects' do
  before do
    @credentials = { username: 'soumya.ray', password: 'mypa$$w0rd' }
    @link_data = { title: 'Gammaly', description: 'lalala', url: '/https://www.youtube.com/watch?v=KZCCWF9idSQ' }
    @playlist_id = 1
    @api_link = { name: 'dfgh', playlist_url: 'https://www.youtube.com/watch?v=12Hzlhpb21I&list=RDCMUC7IcJI8PUf5Z3zKxnZvTBog&start_radio=1dfgh' }
  end

  after do
    WebMock.reset!
  end

  describe 'Playlist Creation' do
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

      link_created = WiseTube::CreateNewLink.new(APP_CONFIG)
                                            .call(current_account: auth_os, playlist_id: @playlist_id, link_data: @link_data)
      link_created = link_created['data']['attributes']

      _(link_created).wont_be_nil
      _(link_created['title']).must_equal @api_link[:title]
      _(link_created['description']).must_equal @api_link[:description]
      _(link_created['url']).must_equal @api_link[:url]
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
