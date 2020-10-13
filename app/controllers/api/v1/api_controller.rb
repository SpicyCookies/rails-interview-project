# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      include Concerns::ExceptionHandler

      # Handle AuthenticationErrors
      rescue_from RailsInterviewProject::Errors::UnauthorizedRequestError, with: :handle_unauthorized_error

      private

      # Internal: Mock API authentication for controller actions
      #
      # Raises TenantNotFound exception on invalid token lookup
      # Returns a Tenant
      def authenticate!
        Tenant.find_by!(api_key: token)
      rescue ActiveRecord::RecordNotFound => e
        raise RailsInterviewProject::Errors::UnauthorizedRequestError, "#{e.class}: #{e.message}"
      end

      def token
        request.headers['Authorization']
      end
    end
  end
end