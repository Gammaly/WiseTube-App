# frozen_string_literal: true

require 'dry/transaction'

module WiseTube
  module Service
    # Retrieves array of all listed firm entities
    class SearchVideos
      include Dry::Transaction

      step :search_videos

      private

      def search_videos(keyword)
        Gateway::Api.new(WiseTube::App.config).search_videos(keyword).then do |result|
          result.success? ? Success(result.payload) : Failure(result.message)
        end
      rescue StandardError => e
        Failure("Could not search videos #{e}")
      end
    end
  end
end
