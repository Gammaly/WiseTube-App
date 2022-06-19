# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test VerifyRegistration Service Objects' do
  before do
    @credentials = { username: 'soumya.ray', password: 'mypa$$w0rd' }
    @registration_data = { username: 'gammaly', email: 'gammaly@gmail.com' }
    @registration_token = SecureMessage.encrypt(@registration_data)
    @registration_data_url = { username: 'gammaly', email: 'gammaly@gmail.com',
                               verification_url: "#{APP_URL}/auth/register/#{@registration_token}" }
    @api_verified_registration = { title: '國立清華大學 服務科學研究所', description: 'ISS NTHU Website' }
  end

  after do
    WebMock.reset!
  end

  describe 'VerifyRegistration' do
    it 'HAPPY: should be able to verified the registration' do
      # auth
      # auth_account_file = 'spec/fixtures/auth_account.json'
      # auth_return_json = File.read(auth_account_file)

      # WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
      #        .with(body: SignedMessage.sign(@credentials).to_json)
      #        .to_return(body: auth_return_json,
      #                   headers: { 'content-type' => 'application/json' })

      # auth_os = JSON.parse(WiseTube::AuthenticateAccount.new.call(**@credentials).to_json, object_class: OpenStruct)

      # VerifyRegistration
      verify_registration_file = 'spec/fixtures/verify_registration.json'
      verify_registration_return_json = File.read(verify_registration_file)

      # WebMock.stub_request(:post, "#{API_URL}/auth/register")
      #        .with(body: SignedMessage.sign(@registration_data_url).to_json)
      #        .to_return(status: 202, body: verify_registration_return_json,
      #                   headers: { 'content-type' => 'application/json' })

      @m = { data: { username: 'gammaly', email: 'gammaly@gmail.com', verification_url: 'http://localhost:9292/auth/register/Sg9sKBC0OKVtzZ1ZkLOGD0GX-aIHRYyNtJ-dTiBcpQyYh7zatSb6nPXGa_Af3Y7JyHSvtm0mZUcNkJMmJdfo90y5Jtl-Zz60r0bXbz7kHityyYvxbE_B_ssS' }, signature: 'vT4wQOJf8iOBxMJi9eSQsClZt9IySyFNpvPm+LjeUJgEJsWfuXmx90uQ7lNEZtijkzj8uJGXerOlLcHfRNZtDA==' }

      WebMock.stub_request(:post, 'http://localhost:3000/api/v1/auth/register')
             .with(
               body: "{\"data\":{\"username\":\"gammaly\",\"email\":\"gammaly@gmail.com\",\"verification_url\":\"http://localhost:9292/auth/register/Dac41vKYr0z3MetCWxyLgQSQiMUmA9UWlIETTyF-B8kHtqDfYf9GktjrSnunl9GBRQZPjXrZMMQl6hZbIVeTKd8fhCsQcz-GGuFZgIpIMdjJMix7c0KlK3Ij\"},\"signature\":\"StB1VxUpNJJzfRe80DwCOE5LUZsymx+IykplTBGpUn8Vh1Tb2kseBE58Ygjzb7gsxXwGPVPGbBgFEq26e7bUCA==\"}"
             )
             .to_return(status: 202, body: verify_registration_return_json, headers: { 'content-type' => 'application/json' })

      verified_registration = WiseTube::VerifyRegistration.new(APP_CONFIG).call(@registration_data)
      verified_registration = verified_registration['attributes']

      _(verified_registration).wont_be_nil
      _(verified_registration['title']).must_equal @api_verified_registration[:title]
      _(verified_registration['description']).must_equal @api_verified_registration[:description]
    end
  end
end
