# frozen_string_literal: true

require 'http'

module WiseTube
  # Returns all playlists belonging to an account
  class GetAllPlaylists
    def initialize(config)
      @config = config
    end

    def call(current_account)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                    .get("#{@config.API_URL}/playlists")

      response.code == 200 ? JSON.parse(response.to_s)['data'] : nil
    end
  end
end
