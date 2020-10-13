# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < ApplicationController
      def index
        questions = Question.all
        render status: :ok, json: questions, each_serializer: QuestionSerializer
      end
    end
  end
end
