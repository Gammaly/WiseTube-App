# frozen_string_literal: true

require 'roda'
require 'json'
require 'erb'

module WiseTube
  # Web controller for WiseTube API
  class App < Roda
    route('search') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @search_route = '/search'

        input = routing.params["input"].to_s
        input = ERB::Util.url_encode(input)

        videos = JSON.parse(Service::SearchVideos.new.call(input).value!, object_class: OpenStruct)['data']

        playlist_info = GetPlaylist.new(App.config).call(
          @current_account, playlist_id
        )
        playlist = Playlist.new(playlist_info)

        view :results, locals: {
          videos: videos, input: input, playlist: playlist
        }

        # POST /playlists/[playlist_id]/links/
        routing.post do
          link_data = Form::NewLink.new.call(routing.params)
          if link_data.failure?
            flash[:error] = Form.message_values(link_data)
            routing.halt
          end

          CreateNewLink.new(App.config).call(
            current_account: @current_account,
            playlist_id:,
            link_data: link_data.to_h
          )

          flash[:notice] = 'Your link was added'
        rescue StandardError => e
          puts "ERROR CREATING LINK: #{e.inspect}"
          flash[:error] = 'Could not add link'
        ensure
          routing.redirect @search_route
        end
      end
    end
  end
end
