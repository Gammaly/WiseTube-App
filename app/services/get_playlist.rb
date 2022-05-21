# frozen_string_literal: true

require 'http'

module WiseTube
  # Returns all playlists belonging to an account
  class GetPlaylist
    def initialize(config)
      @config = config
    end

    def call(current_account, playlist_id)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .get("#{@config.API_URL}/playlists/#{playlist_id}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
