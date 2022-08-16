# frozen_string_literal: true

require 'rails_helper'

describe 'Answer API' do
  describe 'GET /index' do
    let!(:question) { create(:question) }
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answer_1) { create(:answer, reply_to: question) }
      let!(:answer_2) { create(:answer, reply_to: question) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2)
      end

      %w[id body created_at updated_at].each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer_1.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'answer object contains short_body' do
        expect(response.body).to be_json_eql(answer_1.body.truncate(10).to_json).at_path('0/short_body')
      end
    end
  end

  describe 'GET /show' do
    let!(:question) { create(:question) }
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, reply_to: question) }

      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_success
      end

      it 'only 1 object' do
        expect(response.body).to_not be_an_instance_of(Array)
      end

      %w[id body created_at updated_at].each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      it 'answer object contains short_body' do
        expect(response.body).to be_json_eql(answer.body.truncate(10).to_json).at_path('short_body')
      end
    end
  end

  describe 'POST /create' do
    let!(:question) { create(:question) }
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let(:answer) { create(:answer) }

      before { 
        post "/api/v1/questions/#{question.id}/answers/", params: { format: :json, access_token: access_token.token,
                                                                    body: '123qwe', answer: attributes_for(:answer) } }

      it 'returns 201 status code' do
        expect(response).to be_created
      end

      it 'only 1 object' do
        expect(response.body).to_not be_an_instance_of(Array)
      end

      it 'answer object contains valid body' do
        expect(response.body['body']).to eq 'body'
      end

      it 'gives wrong body' do
        post "/api/v1/questions/#{question.id}/answers/", params: { format: :json, access_token: access_token.token,
                                                                    body: '123qwe', answer: attributes_for(:invalid_answer) }
        expect(response).to_not be_success
      end
    end
  end

  def do_request(options = {})
    get '/api/v1/questions/1/', params: { format: :json }.merge(options)
  end
end
