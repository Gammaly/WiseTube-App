# frozen_string_literal: true

require 'roda'
require 'json'
require 'erb'

module WiseTube
  # Web controller for WiseTube API
  class App < Roda
    route('search') do |routing|
      input = routing.params["q"].to_s
      input = ERB::Util.url_encode(input)
      puts input
      videos = JSON.parse(Service::SearchVideos.new.call(input).value!, object_class: OpenStruct)['data']
      puts videos
      view :results, locals: {
        videos: videos, input: input
        }
    end
  end
end
