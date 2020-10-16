# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
  end

  describe '.search' do
    subject { Question.search(title_query_match) }

    context 'with questions that do and do not contain the title param' do
      let(:user_1) do
        FactoryBot.create(:user)
      end

      let(:title_query_match) { 'soup' }
      let(:question_1_title) { "Is cereal #{title_query_match}?" }
      let(:question_2_title) { 'Do you like bread?' }
      let(:question_3_title) { "Do you like #{title_query_match} with bread?" }
      let(:question_1) do
        FactoryBot.create(:question, user_id: user_1.id, title: question_1_title)
      end
      let(:question_2) do
        FactoryBot.create(:question, user_id: user_1.id, title: question_2_title)
      end
      let(:question_3) do
        FactoryBot.create(:question, user_id: user_1.id, title: question_3_title)
      end

      before do
        question_1
        question_2
      end

      it 'includes questions that contain the title param' do
        expect(subject).to include(question_1, question_3)
      end

      it 'does not include questions that do not contain the title param' do
        expect(subject).not_to include(question_2)
      end
    end
  end
end
