# frozen_string_literal: true

module WiseTube
  # Service to add note to link
  class AddNote
    class NoteNotAdded < StandardError; end

    def initialize(config)
      @config = config
    end

    def api_url
      @config.API_URL
    end

    def call(current_account:, link_id:, note:)
      puts "send note:#{note}"
      response = HTTP.auth("Bearer #{current_account.auth_token}")
                     .post("#{api_url}/note/#{link_id}/",
                           json: { note: })

      raise NoteNotAdded unless response.code == 200
    end
  end
end
