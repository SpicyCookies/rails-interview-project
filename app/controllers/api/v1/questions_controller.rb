# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < ApiController
      before_action :authenticate!

      def index
        # Retrieve all public questions
        public_questions = Question.where(private: false)

        result_questions = if search_params[:title].present?
                             # Search for public questions that contain the partial title param string
                             public_questions.search(search_params[:title])
                           else
                             # Only return public questions
                             public_questions
                           end

        render status: :ok, json: result_questions, each_serializer: QuestionSerializer
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
