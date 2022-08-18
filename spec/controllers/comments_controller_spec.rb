# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new comment for question in the database' do
        expect { post :create, params: { comment: attributes_for(:comment, is_question: true), question_id: question, format: :json } }.to change(question.comments, :count).by(1)
      end

      it 'saves the new comment for answer in the database' do
        expect { post :create, params: { comment: attributes_for(:comment, is_question: false), answer_id: answer, question_id: question, format: :json } }.to change(answer.comments, :count).by(1)
      end

      it 'return json response' do
        post :create, params: { comment: attributes_for(:comment, is_question: true), question_id: question, format: :json }
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid attributes' do
      it 'does not save the comment' do
        expect { post :create, params: { comment: attributes_for(:invalid_comment, is_question: true), question_id: question, format: :json } }.to_not change(Comment, :count)
      end

      it 'render create template' do
        post :create, params: { comment: attributes_for(:invalid_answer, is_question: true), question_id: question, format: :json }
        expect(response).to render_template nil
      end
    end
  end
end
