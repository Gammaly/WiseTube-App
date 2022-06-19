# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Service Objects' do
  before do
    @credentials = { username: 'soumya.ray', password: 'mypa$$w0rd' }
    @collaborator = { email: 'galit@gmail.com' }
    @api_account = { username: 'galit', email: 'galit@gmail.com' }
  end

  after do
    WebMock.reset!
  end

  describe 'Remove collaborator' do
    it 'HAPPY: should be able to remove collaborator' do
      auth_account_file = 'spec/fixtures/auth_account.json'
      auth_return_json = File.read(auth_account_file)

      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: SignedMessage.sign(@credentials).to_json)
             .to_return(body: auth_return_json,
                        headers: { 'content-type' => 'application/json' })

      auth_os = JSON.parse(WiseTube::AuthenticateAccount.new.call(**@credentials).to_json, object_class: OpenStruct)

      add_collaborator_file = 'spec/fixtures/add_collaborator.json'
      add_collaborator_json = File.read(add_collaborator_file)

      WebMock.stub_request(:delete, "#{API_URL}/playlists/1/collaborators")
             .with(body: @collaborator.to_json)
             .to_return(body: add_collaborator_json,
                        headers: { 'content-type' => 'application/json' })
  
      response = WiseTube::RemoveCollaborator.new(APP_CONFIG).call(current_account: auth_os, collaborator: @collaborator , playlist_id: 1)
      response = response['attributes']
      _(response).wont_be_nil
      _(response['username']).must_equal @api_account[:username]
      _(response['email']).must_equal @api_account[:email]
    end
  end
end
