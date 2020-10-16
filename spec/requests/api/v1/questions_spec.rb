# frozen_string_literal: true

require 'rails_helper'

describe '/api/v1/questions', type: :request do
  let(:tenant_1) { FactoryBot.create(:tenant) }
  let(:token) { tenant_1.api_key }

  let(:headers) do
    {
      'Authorization' => token.to_s
    }
  end

  before do
    tenant_1
  end

  describe '#index' do
    let(:user_1) do
      FactoryBot.create(:user)
    end
    let(:user_2) do
      FactoryBot.create(:user)
    end

    let(:title_query_match) { 'soup' }
    let(:question_1_title) { "Is cereal #{title_query_match}?" }
    let(:question_2_title) { 'Do you like bread?' }
    let(:private_question_title) { "Is cereal not #{title_query_match}?" }
    let(:question_1) do
      FactoryBot.create(:question, user_id: user_1.id, title: question_1_title, private: false)
    end
    let(:question_2) do
      FactoryBot.create(:question, user_id: user_2.id, title: question_2_title, private: false)
    end
    let(:private_question) do
      FactoryBot.create(:question, user_id: user_2.id, title: private_question_title, private: true)
    end

    let(:answer_1) do
      FactoryBot.create(:answer, user_id: user_1.id, question_id: question_2.id)
    end
    let(:answer_2) do
      FactoryBot.create(:answer, user_id: user_2.id, question_id: question_1.id)
    end

    let(:request_query_params) {{}}
    subject do
      get '/api/v1/questions', params: request_query_params, headers: headers
    end

    before do
      answer_1
      answer_2
      private_question
    end

    context 'with valid request' do
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

      it 'increments the tenant request count' do
        expect { subject }.to change { tenant_1.reload.request_count }.by(1)
      end

      context 'with title in the query params' do
        let(:request_query_params) {{ title: title_query_match }}
        let(:expected_response) do
          [
            expected_question_1
          ]
        end

        it 'successfully retrieves public questions that contain the title param' do
          subject
          response_body = JSON.parse(response.body)
          expect(response_body).to match_array(expected_response)
        end
      end
    end

    context 'with an invalid authorization token' do
      let(:token) { 'invalid token' }
      let(:expected_response) do
        {
          'class' => 'RailsInterviewProject::Errors::UnauthorizedRequestError',
          'message' => "ActiveRecord::RecordNotFound: Couldn't find Tenant"
        }
      end

      it 'renders a 401 status' do
        subject
        expect(response).to have_http_status(401)
      end

      it 'renders an error message' do
        subject
        response_body = JSON.parse(response.body)
        expect(response_body).to eq(expected_response)
      end
    end
  end
end
