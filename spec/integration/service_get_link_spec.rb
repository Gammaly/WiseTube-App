# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'
describe 'Test GetLink Service Objects' do
  before do
    @credentials = { username: 'soumya.ray', password: 'mypa$$w0rd' }
    @link_id = 'f91a942a-6371-4e36-bfb4-bc1c54f535e8'
    @api_playlist = { title: '國立清華大學 服務科學研究所', description: 'ISS NTHU Website' }
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
             .to_return(status: 200, body: get_link_return_json,
                        headers: { 'content-type' => 'application/json' })

      # WebMock.stub_request(:get, 'http://localhost:3000/api/v1/playlists/f91a942a-6371-4e36-bfb4-bc1c54f535e8')
      #        .with(
      #          headers: {
      #            'Authorization' => 'Bearer uDs62csNiDm4c7V_3KtABoHucNXsiU4JPG8uUkTn6w419t4AVTalMiSe9Pw74hRnlhrefPhCVKW3Y5PNDLsg5N1Sp9_47iG5vwtf8Xq4q5WI4_7H10eJyVpJRpW2xrw_3BoAkbDbRa5wuv7fO7wRz8Ay1V_Rh9zFl7QjvnHufeqSzr4LVOKKGnwNc3WdtcwF7ZfuX55Oe4JUOiaxAjbLIcW6-Cqs77zvpLbN',
      #            'Connection' => 'close',
      #            'Host' => 'localhost:3000',
      #            'User-Agent' => 'http.rb/5.0.4'
      #          }
      #        )
      #        .to_return(status: 200, body: '', headers: {})

      playlists_list = WiseTube::GetPlaylist.new(APP_CONFIG).call(auth_os, @link_id)
      playlists_list = playlists_list['attributes']

      _(playlists_list).wont_be_nil
      _(playlists_list['title']).must_equal @api_playlist[:title]
      _(playlists_list['description']).must_equal @api_playlist[:description]
    end
  end
end
