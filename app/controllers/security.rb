# frozen_string_literal: true

require_relative './app'
require 'roda'
require 'rack/ssl-enforcer'
require 'secure_headers'

module Credence
  # Configuration for the API
  class App < Roda
    plugin :environments
    plugin :multi_route

    FONT_SRC = %w[https://cdn.jsdelivr.net].freeze
    SCRIPT_SRC = %w[https://cdn.jsdelivr.net].freeze
    STYLE_SRC = %w[https://bootswatch.com https://cdn.jsdelivr.net].freeze

    configure :production do
      use Rack::SslEnforcer, hsts: true
    end

    ## Uncomment to drop the login session in case of any violation
    # use Rack::Protection, reaction: :drop_session
    use SecureHeaders::Middleware

    SecureHeaders::Configuration.default do |config|
      config.cookies = {
        secure: true,
        httponly: true,
        samesite: {
          strict: true
        }
      }

      config.x_frame_options = 'DENY'
      config.x_content_type_options = 'nosniff'
      config.x_xss_protection = '1'
      config.x_permitted_cross_domain_policies = 'none'
      config.referrer_policy = 'origin-when-cross-origin'

