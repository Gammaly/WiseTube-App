# frozen_string_literal: true

require 'roda'

module WiseTube
  # Web controller for WiseTube API
  class App < Roda
    route('video') do |routing|
      link = routing.params["q"].to_s
      puts link
      view :video, locals: {
        link: link
        }
    end
  end
end
