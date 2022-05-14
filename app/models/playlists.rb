# frozen_string_literal: true

require_relative 'playlist'

module WiseTube
  # Behaviors of the currently logged in account
  class Playlists
    attr_reader :all

    def initialize(playlists_list)
      @all = playlists_list.map do |playlist|
        Playlist.new(playlist)
      end
    end
  end
end
