# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Service Objects' do
  before do
    @keyword = 'goat'
    @collaborator = { email: 'galit@gmail.com' }
    @api_account = { username: 'galit', email: 'galit@gmail.com' }
  end

  after do
    WebMock.reset!
  end

  describe 'Search videos' do
    it 'HAPPY: search videos' do
      video_search_file = 'spec/fixtures/video_search.json'
      video_search_json = File.read(video_search_file)

      WebMock.stub_request(:get, "#{API_URL}/search?q=goat")
             .with(headers: { 'Accept' => 'application/json' })
             .to_return(body: video_search_json,
                        headers: { 'content-type' => 'application/json' })

      response = WiseTube::Service::SearchVideos.new.call(@keyword)
      _(response).wont_be_nil
    end
  end
end
