require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create :question }
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect do
          post :create, params: { answer: attributes_for(:answer), question_id: question, format: :json }
        end.to change(question.answers, :count).by(1)
      end

      it 'return json response' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :json }
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :json } }
          .to_not change(Answer, :count)
      end

      it 'render crate template' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :json }
        expect(response).to render_template nil
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, reply_to: question) }

    it 'assings the requested answer to @answer' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, params: { id: answer.id, question_id: question.id, answer: { body: 'MyAnswer' }, format: :js }
      answer.reload
      expect(answer.body).to eq 'MyAnswer'
    end

    it 'render update template' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
      expect(response).to redirect_to root_path
    end
  end
end
