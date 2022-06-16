# frozen_string_literal: true

require 'http'

module WiseTube
  module Gateway
    # Infrastructure to call SECond API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def search_videos(keyword)
        @request.search_videos(keyword)
      end

      def get_captions(video_id)
        @request.get_captions(video_id)
      end

      # HTTP request transmitter
      class Request
        def initialize(config)
          @api_root = config.API_URL
        end

        def get_root # rubocop:disable Naming/AccessorMethodName
          call_api('get')
        end

        def search_videos(keyword)
          call_api('get', ['search'], 'q' => keyword)
        end

        def get_captions(video_id)
          call_api('get', ['captions'], 'q' => video_id)
        end

        private

        def params_str(params)
          params.map { |key, value| "#{key}=#{value}" }.join('&')
            .then { |str| str ? '?' + str : '' }
        end

        def call_api(method, resources = [], params = {})
          api_path = @api_root
          url = [api_path, resources].flatten.join('/') + params_str(params)

          HTTP.headers('Accept' => 'application/json').send(method, url)
            .then { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "Invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_CODES = (200..299) # .freeze

        def success?
          code.between?(SUCCESS_CODES.first, SUCCESS_CODES.last)
        end

        def failure?
          !success?
        end

        def ok?
          code == 200
        end

        def added?
          code == 201
        end

        def processing?
          code == 202
        end

        def message
          JSON.parse(payload)['message']
        end

        def payload
          body.to_s
        end
      end
    end
  end
end