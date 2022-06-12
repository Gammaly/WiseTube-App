# frozen_string_literal: true

require 'http'

module WiseTube
  # Returns all search results
  class GetSearch
    def initialize(config)
      @config = config
    end

    def call(user, search_result)
      response = HTTP.auth("Bearer #{user.auth_token}")
                     .get("#{@config.API_URL}/#{search_result}")

      response.code == 200 ? JSON.parse(response.body.to_s)['data'] : nil
    end
  end
end
