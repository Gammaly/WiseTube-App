# frozen_string_literal: true

require 'roda'
require 'json'
require 'erb'

module WiseTube
  # Web controller for WiseTube API
  class App < Roda
    route('search') do |routing|
      q = routing.params["q"].to_s
      q = ERB::Util.url_encode(q)
      videos = JSON.parse(Service::SearchVideos.new.call(q).value!, object_class: OpenStruct)['data']
      view :results, locals: {
        videos:, q:
      }
    end
  end
end
