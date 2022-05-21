# frozen_string_literal: true

require_relative 'playlist'

module WiseTube
  # Behaviors of the currently logged in account
  class Link
    attr_reader :id, :title, :description, # basic info
                :url, :image,
                :playlist # full details

    def initialize(info)
      process_attributes(info['attributes'])
      process_included(info['include'])
    end

    private

    def process_attributes(attributes)
      @id             = attributes['id']
      @title          = attributes['title']
      @description    = attributes['description']
      @url            = attributes['url']
      @image          = attributes['image']
    end

    def process_included(included)
      @playlist = Playlist.new(included['playlist'])
    end
  end
end
