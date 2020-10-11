# frozen_string_literal: true

module Api
  module V1
    class QuestionSerializer < ActiveModel::Serializer
      attributes :id, :title, :user_id, :user_name

      has_many :answers

      def user_name
        object.user.name
      end

      class AnswerSerializer < ActiveModel::Serializer
        attributes :id, :body, :user_id, :user_name

        def user_name
          object.user.name
        end
      end
    end
  end
end
