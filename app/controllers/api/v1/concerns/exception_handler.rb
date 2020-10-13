# frozen_string_literal: true

module Api
  module V1
    module Concerns
      module ExceptionHandler
        extend ActiveSupport::Concern

        def render_error(code, msg)
          render status: code, json: { error: msg }.to_json
        end

        def handle_unauthorized_error(error)
          render_error :unauthorized, error.message
        end
      end
    end
  end
end
