# frozen_string_literal: true

require 'roda'
require_relative './app'

module WiseTube
  # Web controller for WiseTube API
  class App < Roda
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
    end
  end
end
