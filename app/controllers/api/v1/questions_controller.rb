# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < ApiController
      before_action :authenticate!

      def index
        # Only retrieve public questions
        questions = Question.where(private: false)
        render status: :ok, json: questions, each_serializer: QuestionSerializer
      end
    end
  end
end
