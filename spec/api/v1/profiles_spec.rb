# frozen_string_literal: true

require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like 'API Authenticable'

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it 'return 200 status' do
        expect(response).to be_success
      end

      %w[id email created_at updated_at admin].each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w[password encrypted_password].each do |attr|
        it "dont contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /users' do
    context 'authorized' do
      let!(:user) { create(:user) }
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/users', params: { format: :json, access_token: access_token.token } }

      it 'return 200 status' do
        expect(response).to be_success
      end

      it 'contains additional user' do
        parsed_response = JSON.parse(response.body).first
        expect(parsed_response['id']).to eq User.where.not(id: me.id).first.id
      end

      it 'dont contains me' do
        expect(JSON.parse(response.body)).to_not include me
      end
    end
  end
  def do_request(options = {})
    get '/api/v1/profiles/users', params: { format: :json }.merge(options)
  end
end
