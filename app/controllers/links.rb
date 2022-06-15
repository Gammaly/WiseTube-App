# frozen_string_literal: true

require 'roda'

module WiseTube
  # Web controller for WiseTube API
  class App < Roda
    route('links') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      # GET /links/[link_id]
      routing.get(String) do |link_id|
        link_info = GetLink.new(App.config)
                           .call(@current_account, link_id)
        link = Link.new(link_info)

        # view :link, locals: {
        #   current_account: @current_account, link:
        # }

        view :video, locals: {
          current_account: @current_account, link: link, link_id:
        }
      end
    end
  end
end
