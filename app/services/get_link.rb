# frozen_string_literal: true

require 'http'

module WiseTube
  # Returns all links belonging to a playlist
  class GetLink
    def initialize(config)
      @config = config
    end

    def call(user, link_id)
      response = HTTP.auth("Bearer #{user.auth_token}")
                     .get("#{@config.API_URL}/links/#{link_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
