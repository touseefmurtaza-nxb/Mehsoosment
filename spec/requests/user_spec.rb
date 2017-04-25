require 'rails_helper'
RSpec.describe 'Users API', type: :request do

  describe 'POST /api/v1/users' do
    let(:valid_attributes) { { phone_number: '03354435636' } }
    let(:invalid_attributes) { { phone_number: '' } }

    context 'when the request is valid' do
      before { post '/api/v1/users', params: valid_attributes }
      it 'User Created' do
        expect(response.status).to eq(200)
      end
    end
    context 'when the request is invalid' do
      before { post '/api/v1/users', params: invalid_attributes }
      it 'User does not create' do
        res = JSON.parse(response.body)
        expect(res["status"]).to eq(400)
      end
    end
  end
end