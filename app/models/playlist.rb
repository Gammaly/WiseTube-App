# frozen_string_literal: true

module WiseTube
  # Behaviors of the currently logged in account
  class Playlist
    attr_reader :id, :name, :playlist_url

    def initialize(playlist_info)
      @id = playlist_info['attributes']['id']
      @name = playlist_info['attributes']['name']
      @playlist_url = playlist_info['attributes']['playlist_url']
    end
  end
end
