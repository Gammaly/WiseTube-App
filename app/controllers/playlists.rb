# frozen_string_literal: true

require 'roda'

module WiseTube
  # Web controller for WiseTube API
  class App < Roda
    route('playlists') do |routing|
      routing.on do
        # GET /playlists/
        routing.get do
          if @current_account.logged_in?
            playlist_list = GetAllPlaylists.new(App.config).call(@current_account)

            playlists = Playlists.new(playlist_list)

            view :playlists_all,
                 locals: { current_user: @current_account, playlists: }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end