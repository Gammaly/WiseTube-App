# frozen_string_literal: true

require_relative 'form_base'

module WiseTube
  module Form
    # New Link
    class NewLink < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_link.yml')

      params do
        required(:title).filled(max_size?: 256, format?: FILENAME_REGEX)
        required(:description).maybe(:string)
        required(:url).filled(format?: PATH_REGEX)
        required(:image).filled(format?: PATH_REGEX)
      end
    end
  end
end
