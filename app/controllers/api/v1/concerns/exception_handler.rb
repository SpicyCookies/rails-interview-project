# frozen_string_literal: true

module Api
  module V1
    module Concerns
      module ExceptionHandler
        extend ActiveSupport::Concern

        def render_error(code, error_class, error_msg)
          error_response = {
            class: error_class.to_s,
            message: error_msg
          }
          render status: code, json: error_response.to_json
        end

        def handle_unauthorized_error(error)
          render_error :unauthorized, error.class, error.message
        end
      end
    end
  end
end
