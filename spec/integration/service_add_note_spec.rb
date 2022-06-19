# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'
describe 'Test CreateNewLink Service Objects' do
  before do
    @credentials = { username: 'soumya.ray', password: 'mypa$$w0rd' }
    @link_id = 1
    @note = { note: 'this is a test note' }
    @note_data = { note: 'this is a test note', id: '9d3211cd-c394-4094-b67e-9d2595434768'}
  end

  after do
    WebMock.reset!
  end

  describe 'Note Creation' do
    it 'HAPPY: should be able to create new note into a link for an accounts' do
      # auth
      auth_account_file = 'spec/fixtures/auth_account.json'
      auth_return_json = File.read(auth_account_file)

      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: SignedMessage.sign(@credentials).to_json)
             .to_return(body: auth_return_json,
                        headers: { 'content-type' => 'application/json' })

      auth_os = JSON.parse(WiseTube::AuthenticateAccount.new.call(**@credentials).to_json, object_class: OpenStruct)

      # note
      create_note_file = 'spec/fixtures/create_note.json'
      create_note_json = File.read(create_note_file)

      WebMock.stub_request(:post, "#{API_URL}/note/#{@link_id}/")
             .with(body: @note.to_json)
             .to_return(status: 200, body: create_note_json,
                        headers: { 'content-type' => 'application/json' })

      note_created = WiseTube::AddNote.new(APP_CONFIG)
                                            .call(current_account: auth_os, link_id: @link_id, **@note)
      note_created = note_created['attributes'] 
      _(note_created).wont_be_nil
      _(note_created['note']).must_equal @note_data[:note]
      _(note_created['id']).must_equal @note_data[:id]
    end
  end
end
