# frozen_string_literal: true

module WiseTube
  # Service to add collaborator to playlist
  class AddCollaborator
    class CollaboratorNotAdded < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, collaborator:, playlist_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .put("#{api_url}/playlists/#{playlist_id}/collaborators",
                          json: { email: collaborator[:email] })
      raise CollaboratorNotAdded unless response.code == 200

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
