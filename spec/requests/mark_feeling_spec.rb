require 'rails_helper'
RSpec.describe 'Mark Feeling API', type: :request do

  let!(:user) { create(:user) }
  let!(:mark_feelings) { create_list(:mark_feeling, 10, user_id: user.id) }
  let(:user_id) { user.id }
  let(:mark_feeling_id) { mark_feelings.first.id }

  describe 'POST /api/v1/mark_feelings' do
    let(:valid_attributes) { { latitude: mark_feelings.first.latitude, longitude: mark_feelings.first.longitude, user_id: mark_feelings.first.user_id, mark_type: mark_feelings.first.mark_type } }
    let(:invalid_latitude) { { latitude: '' } }
    let(:invalid_longitude) { { longitude: '' } }
    let(:invalid_mark_type) { { mark_type: 7 } }
    let(:invalid_user_id) { { user_id: 0 } }

    context 'when the request is valid' do
      before { post '/api/v1/mark_feelings', params: valid_attributes }
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