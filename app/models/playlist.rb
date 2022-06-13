# frozen_string_literal: true
require 'pp'
module WiseTube
  # Behaviors of the currently logged in account
  class Playlist
    attr_reader :id, :name, :playlist_url, # basic info
                :owner, :collaborators, :links, :policies # full details

    def initialize(playlist_info)
      process_attributes(playlist_info['attributes'])
      process_relationships(playlist_info['relationships'])
      process_policies(playlist_info['policies'])
    end

    private

    def process_attributes(attributes)
      @id = attributes['id']
      @name = attributes['name']
      @playlist_url = attributes['playlist_url']
    end

    def process_relationships(relationships)
      return unless relationships

      @owner = Account.new(relationships['owner'])
      @collaborators = process_collaborators(relationships['collaborators'])
      @links = process_links(relationships['links'])
    end

    def process_policies(policies)
      @policies = OpenStruct.new(policies)
    end

    def process_links(links_info)
      return nil unless links_info

      links_info.map { |link_info| Link.new(link_info) }
    end

    def process_collaborators(collaborators)
      return nil unless collaborators

      collaborators.map { |account_info| Account.new(account_info) }
    end
  end
end
