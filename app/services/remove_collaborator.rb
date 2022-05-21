# frozen_string_literal: true

module WiseTube
  # Service to add collaborator to playlist
  class RemoveCollaborator
    class CollaboratorNotRemoved < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, collaborator:, playlist_id:)
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .delete("#{api_url}/playlists/#{playlist_id}/collaborators",
                             json: { email: collaborator[:email] })

      raise CollaboratorNotRemoved unless response.code == 200
    end
  end
end
