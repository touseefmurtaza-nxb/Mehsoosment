require 'rails_helper'
RSpec.describe 'User Location API', type: :request do

  let!(:user) { create(:user) }
  let!(:user_locations) { create_list(:user_location, 10, user_id: user.id) }
  let(:user_id) { user.id }
  let(:user_location_id) { user_locations.first.id }

  describe 'POST /api/v1/user_locations' do
    let(:valid_attributes) { { latitude: user_locations.first.latitude, longitude: user_locations.first.longitude, user_id: user_locations.first.user_id } }
    let(:invalid_latitude) { { latitude: '' } }
    let(:invalid_longitude) { { longitude: '' } }
    let(:invalid_user_id) { { user_id: '' } }

    context 'when the request is valid' do
      before { post '/api/v1/user_locations', params: valid_attributes }
      it 'returns location saved and return markers and stats' do
        expect(response.status).to eq(200)
      end
    end

    context 'when the request contain invalid latitude' do
      before { post '/api/v1/users', params: invalid_latitude }
      it 'returns location did not saved' do
        res = JSON.parse(response.body)
        expect(res["status"]).to eq(400)
      end
    end

    context 'when the request contain invalid longitude' do
      before { post '/api/v1/users', params: invalid_longitude }
      it 'returns location did not saved' do
        res = JSON.parse(response.body)
        expect(res["status"]).to eq(400)
      end
    end

    context 'when the request contain invalid user id' do
      before { post '/api/v1/users', params: invalid_user_id}
      it 'returns location did not saved' do
        res = JSON.parse(response.body)
        expect(res["status"]).to eq(400)
      end
    end

  end
end