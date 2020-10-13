# frozen_string_literal: true

require 'rails_helper'

describe '/api/v1/questions', type: :request do
  describe '#index' do
    let(:user_1) do
      FactoryBot.create(:user)
    end
    let(:user_2) do
      FactoryBot.create(:user)
    end

    let(:question_1) do
      FactoryBot.create(:question, user_id: user_1.id)
    end
    let(:question_2) do
      FactoryBot.create(:question, user_id: user_2.id)
    end
    let(:private_question) do
      FactoryBot.create(:question, user_id: user_2.id, private: true)
    end

    let(:answer_1) do
      FactoryBot.create(:answer, user_id: user_1.id, question_id: question_2.id)
    end
    let(:answer_2) do
      FactoryBot.create(:answer, user_id: user_2.id, question_id: question_1.id)
    end

    subject do
      get '/api/v1/questions'
    end

    before do
      answer_1
      answer_2
      private_question
    end

    context 'with no query params passed' do
      let(:expected_answer_1) do
        {
          'id' => answer_1.id,
          'body' => answer_1.body,
          'user_id' => user_1.id,
          'user_name' => user_1.name
        }
      end
      let(:expected_answer_2) do
        {
          'id' => answer_2.id,
          'body' => answer_2.body,
          'user_id' => user_2.id,
          'user_name' => user_2.name
        }
      end

      let(:expected_question_1) do
        {
          'id' => question_1.id,
          'title' => question_1.title,
          'user_id' => user_1.id,
          'user_name' => user_1.name,
          'answers' => [
            expected_answer_2
          ]
        }
      end
      let(:expected_question_2) do
        {
          'id' => question_2.id,
          'title' => question_2.title,
          'user_id' => user_2.id,
          'user_name' => user_2.name,
          'answers' => [
            expected_answer_1
          ]
        }
      end

      let(:expected_response) do
        [
          expected_question_2,
          expected_question_1
        ]
      end

      it 'renders a 200 status' do
        subject
        expect(response).to have_http_status(200)
      end

      it 'successfully retrieves public questions' do
        subject
        response_body = JSON.parse(response.body)
        expect(response_body).to match_array(expected_response)
      end
    end
  end
end
