# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test StringSecurity' do
  it 'HAPPY: should be able to judge the entropy of a string' do
    string = 'UnitTest'
    string_security = StringSecurity.entropy(string)

    _(string_security).wont_be_nil
  end
end
