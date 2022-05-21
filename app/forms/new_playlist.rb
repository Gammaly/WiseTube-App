# frozen_string_literal: true

require_relative 'form_base'

module WiseTube
  module Form
    # New Playlist
    class NewPlaylist < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_playlist.yml')

      params do
        required(:name).filled
        optional(:playlist_url).maybe(format?: URI::DEFAULT_PARSER.make_regexp)
      end
    end
  end
end
