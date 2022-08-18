# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, reply_to: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w[id title body created_at updated_at].each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path('0/short_title')
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('0/answers')
        end

        %w[id body created_at updated_at].each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }

      before { post "/api/v1/questions", params: { format: :json, access_token: access_token.token,
                                                   body: '123qwe', title: '123',
                                                   question: attributes_for(:question) } }

      it 'returns 201 status code' do
        expect(response).to be_created
      end

      it 'only 1 object' do
        expect(response.body).to_not be_an_instance_of(Array)
      end

      it 'answer object contains valid body' do
        expect(response.body['body']).to eq 'body'
        expect(response.body['title']).to eq 'title'
      end

      it 'gives wrong body/title' do
        post "/api/v1/questions/#{question.id}/answers/", params: { format: :json, access_token: access_token.token,
                                                                    body: '123qwe', answer: attributes_for(:invalid_answer) }
        expect(response).to_not be_success
      end
    end
  end

  def do_request(options = {})
    get '/api/v1/questions', params: { format: :json }.merge(options)
  end
end 
