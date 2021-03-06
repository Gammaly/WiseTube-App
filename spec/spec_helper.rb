# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'

require_relative 'test_load_all'

API_URL = app.config.API_URL
APP_URL = app.config.APP_URL
APP_CONFIG = app.config
