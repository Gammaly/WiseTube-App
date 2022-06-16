# frozen_string_literal: true

require_relative 'playlist'

module WiseTube
  # Behaviors of the currently logged in account
  class Link
    attr_reader :id, :title, :description, # basic info
                :url, :image, :note, :comment, :captions, :video_id,
                :playlist # full details

    def initialize(info)
      process_attributes(info['attributes'])
      process_included(info['included'])
    end

    private

    def process_attributes(attributes)
      @id             = attributes['id']
      @title          = attributes['title']
      @description    = attributes['description']
      @url            = attributes['url']
      @image          = attributes['image']
      @note           = attributes['note']
      #@comment      = attributes['comment']
      #@captions     = attributes['captions']
      @video_id       = attributes['url'].match(%r{https://www\.youtube\.com/watch\?v=(.*)}i).captures.first
    end

    def process_included(included)
      @playlist = Playlist.new(included['playlist'])
    end
  end
end
