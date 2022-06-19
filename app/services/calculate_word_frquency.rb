# frozen_string_literal: true

require 'http'
require 'dry/transaction'
require 'words_counted'
require 'stopwords'

module WiseTube
  module Service
    # Returns a word frquency list for the video
    class CalculateWordFrequency
      include Dry::Transaction

      step :get_video_captions
      step :calculate_word_frequency

      class NotCalculateError < StandardError; end
      class ApiServerError < StandardError; end

      private

      def get_video_captions(input)
        Gateway::Api.new(WiseTube::App.config).get_captions(input).then do |result|
          puts result.data
          result.success? ? Success(result.data) : Failure(result.message)
        end
      rescue StandardError => e
        Failure("Could not get video's captions: #{e}")
      end

      def calculate_word_frequency(input)
        filter = Stopwords::Snowball::Filter.new 'en'
        counter = WordsCounted.count(input, exclude: ->(t) { filter.stopword? t })
        words_frequency = counter.token_frequency[0..149].select { |term_frequency| term_frequency[0].length > 2 }
        Success(words_frequency)
      rescue StandardError => e
        Failure("Could not get video's captions: #{e}")
      end
    end
  end
end
