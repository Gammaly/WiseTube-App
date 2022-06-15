# frozen_string_literal: true

require 'dry/transaction'
require 'http'

module WiseTube
  module Service
    # Retrieves array of all listed firm entities
    class EditNote
      include Dry::Transaction

      step :search_videos

      private

      def initialize(config)
        @config = config
      end

      def api_url
        @config.API_URL
      end

      def call(current_account:, playlist_id:, link_data:)
        config_url = "#{api_url}/playlists/#{playlist_id}/links"
        response = HTTP.auth("Bearer #{current_account.auth_token}")
                       .post(config_url, json: link_data)

        response.code == 201 ? JSON.parse(response.body.to_s) : raise
      end
    end
  end
end
