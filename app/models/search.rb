# frozen_string_literal: true

require_relative 'playlist'

module WiseTube
  # Behaviors of the currently logged in account
  class Search
    attr_reader :id, :name, :channel, :description, # basic info
                :url, :image # full details

    def initialize(info)
      process_attributes(info['attributes'])
      process_included(info['included'])
    end

    private

    def process_attributes(attributes)
      @id             = attributes['id']
      @name           = attributes['name']
      @channel        = attributes['channel']
      @description    = attributes['description']
      @url            = attributes['url']
      @image          = attributes['image']
    end

    def process_included(included)
      @playlist = Playlist.new(included['playlist'])
    end
  end
end
