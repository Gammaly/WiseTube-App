# frozen_string_literal: true

require 'roda'
require 'json'

module WiseTube
  # Web controller for WiseTube API
  class App < Roda
    route('video') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      # GET /links/[link_id]
      routing.get(String) do |link_id|
        link_info = GetLink.new(App.config)
                           .call(@current_account, link_id)
        link = Link.new(link_info)

        words_frequency = Service::CalculateWordFrequency.new.call(link.video_id).value!

        view :video, locals: {
          current_account: @current_account, link:, words_frequency:
        }
      end
    end
  end
end
