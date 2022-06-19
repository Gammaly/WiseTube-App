# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Service Objects' do
  before do
    @video_id = '2OcLD5UIqxM'
    @collaborator = { email: 'galit@gmail.com' }
    @api_account = { username: 'galit', email: 'galit@gmail.com' }
  end

  after do
    WebMock.reset!
  end

  describe 'Calculate word frequency' do
    it 'HAPPY: should be able to calculate word freqency' do
      word_freqency_file = 'spec/fixtures/word_freqency.json'
      word_freqency_json = File.read(word_freqency_file)

      WebMock.stub_request(:get, "#{API_URL}/captions?q=2OcLD5UIqxM")
             .with(headers: { 'Accept' => 'application/json' })
             .to_return(body: word_freqency_json,
                        headers: { 'content-type' => 'application/json' })
  
      response = WiseTube::Service::CalculateWordFrequency.new.call(@video_id)
      _(response).wont_be_nil
    end
  end
end
