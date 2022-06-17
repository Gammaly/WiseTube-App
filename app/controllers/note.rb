# frozen_string_literal: true

require_relative './app'
require 'pp'

module WiseTube
  # Web controller for WiseTube API
  class App < Roda
    route('note') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      routing.on String do |link_id|
        @link_route = "/video/#{link_id}"
        # POST api/v1/note/[ID]
        routing.post do
          note = routing.params['video-note']
          puts "note: #{note}"
          AddNote.new(App.config).call(
            current_account: @current_account,
            link_id:,
            note:
          )

          routing.redirect @link_route
        rescue StandardError => e
          puts "ADD NOTE ERROR: #{e.inspect}"
          routing.halt 500, { message: 'API server error' }.to_json
        end
      end
    end
  end
end
