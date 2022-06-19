# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test secure lib' do
  describe 'Test StringSecurity' do
    it 'HAPPY: should be able to judge the entropy of a string' do
      string = 'UnitTest'
      string_security = StringSecurity.entropy(string)

      _(string_security).wont_be_nil
    end
  end

  describe 'Test SecureMessage' do
    it 'HAPPY: should be able to encrypt a message' do
      message = 'SEC 2022'
      message_encrypted = SecureMessage.encrypt(message)

      _(message_encrypted).wont_be_nil
      _(message_encrypted).wont_equal message
    end

    it 'HAPPY: should be able to decrypt a message' do
      message = 'SEC 2022'
      message_encrypted = SecureMessage.encrypt(message)
      message_decrypted = SecureMessage.decrypt(message_encrypted)

      _(message_decrypted).wont_be_nil
      _(message_decrypted).must_equal message
    end
  end
end
