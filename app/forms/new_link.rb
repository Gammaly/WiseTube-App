# frozen_string_literal: true

require_relative 'form_base'

module Credence
  module Form
    class NewDocument < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/new_document.yml')

      params do
        required(:title).filled(max_size?: 256, format?: FILENAME_REGEX)
        required(:description).maybe(:string)
        required(:url).filled(format?: PATH_REGEX)
        required(:image).filled(format?: PATH_REGEX)
      end
    end
  end
end
