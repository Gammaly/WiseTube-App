# frozen_string_literal: true

require 'roda'
<<<<<<< HEAD
require_relative './app'
=======
require 'json'
require 'erb'
>>>>>>> f2e2bb1... Finish search videos

module WiseTube
  # Web controller for WiseTube API
  class App < Roda
<<<<<<< HEAD
    route('results') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      # GET /results
      routing.get(String) do |results|
        search_info = GetSearch.new(App.config)
                               .call(@current_account, results)
        search_result = Search.new(search_info)

        view :search_result, locals: {
          current_account: @current_account, search_result:
        }
      end
=======
    route('search') do |routing|
      q = routing.params["q"].to_s
      q = ERB::Util.url_encode(q)
      puts q
      videos = JSON.parse(Service::SearchVideos.new.call(q).value!, object_class: OpenStruct)['data']
      view :results, locals: {
        videos: videos
        }
>>>>>>> f2e2bb1... Finish search videos
    end
  end
end
