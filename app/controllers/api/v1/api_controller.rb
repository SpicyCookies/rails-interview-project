# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      include Concerns::ExceptionHandler

      # Handle UnauthorizedRequestError
      rescue_from RailsInterviewProject::Errors::UnauthorizedRequestError, with: :handle_unauthorized_error

      private

      # Internal: Mock API authentication for controller actions
      #
      # Raises UnauthorizedRequestError exception on invalid token lookup
      # Returns a boolean and increments the authenticated tenant
      def authenticate!
        tenant = Tenant.find_by!(api_key: token)
        tenant.update(request_count: tenant.request_count + 1)
      rescue ActiveRecord::RecordNotFound => e
        raise RailsInterviewProject::Errors::UnauthorizedRequestError, "#{e.class}: #{e.message}"
      end

      def token
        request.headers['Authorization']
      end
    end
  end
end
