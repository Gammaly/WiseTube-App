# frozen_string_literal: true

require 'roda'

module WiseTube
  # Web controller for WiseTube API
  class App < Roda
    route('playlists') do |routing|
      routing.on do
        routing.redirect '/auth/login' unless @current_account.logged_in?
        @playlists_route = '/playlists'

        routing.on(String) do |playlist_id|
          @playlist_route = "#{@playlists_route}/#{playlist_id}"

          # GET /playlists/[playlist_id]
          routing.get do
            playlist_info = GetPlaylist.new(App.config).call(
              @current_account, playlist_id
            )

            playlist = Playlist.new(playlist_info)
            puts playlist
            view :playlist, locals: {
              current_account: @current_account, playlist:
            }
          rescue StandardError => e
            puts "#{e.inspect}\n#{e.backtrace}"
            flash[:error] = 'Playlist not found'
            routing.redirect @playlists_route
          end

          # POST /playlists/[playlist_id]/collaborators
          routing.post('collaborators') do
            action = routing.params['action']
            collaborator_info = Form::CollaboratorEmail.new.call(routing.params)
            if collaborator_info.failure?
              flash[:error] = Form.validation_errors(collaborator_info)
              routing.halt
            end

            task_list = {
              'add' => { service: AddCollaborator,
                         message: 'Added new collaborator to playlist' },
              'remove' => { service: RemoveCollaborator,
                            message: 'Removed collaborator from playlist' }
            }

            task = task_list[action]
            task[:service].new(App.config).call(
              current_account: @current_account,
              collaborator: collaborator_info,
              playlist_id:
            )
            flash[:notice] = task[:message]

          rescue StandardError
            flash[:error] = 'Could not find collaborator'
          ensure
            routing.redirect @playlist_route
          end

          # POST /playlists/[playlist_id]/links/
          routing.post('links') do
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
            puts "ERROR CREATING DOCUMENT: #{e.inspect}"
            flash[:error] = 'Could not add link'
          ensure
            routing.redirect @playlist_route
          end
        end

        # GET /playlists/
        routing.get do
          playlist_list = GetAllPlaylists.new(App.config).call(@current_account)

          playlists = Playlists.new(playlist_list)

          view :playlists_all, locals: {
            current_account: @current_account, playlists:
          }
        end

        # POST /playlists/
        routing.post do
          routing.redirect '/auth/login' unless @current_account.logged_in?

          playlist_data = Form::NewPlaylist.new.call(routing.params)
          if playlist_data.failure?
            flash[:error] = Form.message_values(playlist_data)
            routing.halt
          end

          CreateNewPlaylist.new(App.config).call(
            current_account: @current_account,
            playlist_data: playlist_data.to_h
          )

          flash[:notice] = 'Add links and collaborators to your new playlist'
        rescue StandardError => e
          puts "FAILURE Creating Playlist: #{e.inspect}"
          flash[:error] = 'Could not create playlist'
        ensure
          routing.redirect @playlists_route
        end
      end
    end
  end
end
