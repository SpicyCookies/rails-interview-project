# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < ApiController
      before_action :authenticate!

      def index
        questions = if search_params[:title].present?
          # Search for public questions that contain the partial 'title' string
          Question.where(private: false).search(search_params[:title])
        else
          # Only retrieve public questions
          Question.where(private: false)
        end

        render status: :ok, json: questions, each_serializer: QuestionSerializer
      end

      private

      #
      # Helper methods
      #

      def search_params
        params.permit(:title)
      end
    end
  end
end
