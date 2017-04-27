require 'rails_helper'
RSpec.describe 'Users API', type: :request do

  let!(:users) { create_list(:user, 10) }
  let(:user_id) { users.first.id }

  describe 'POST /api/v1/users' do
    let(:valid_attributes) { { phone_number: users.first.phone_number } }
    let(:invalid_attributes) { { phone_number: '' } }

    context 'when the request is valid' do
      before { post '/api/v1/users', params: valid_attributes }
      it 'returns user created' do
        expect(response.status).to eq(200)
      end
    end
    context 'when the request is invalid' do
      before { post '/api/v1/users', params: invalid_attributes }
      it 'returns user does not create' do
        res = JSON.parse(response.body)
        expect(res["status"]).to eq(400)
      end
    end
  end

  describe 'POST /api/v1/users/verify' do
    let(:valid_attributes) {{ uuid: users.first.uuid, pin: users.first.pin }}
    let(:invalid_pin) { { uuid: users.first.uuid, pin: "0000" } }
    let(:pin_expired) { { uuid: users.first.uuid, pin: (users.first.expires_at = Time.zone.now) } }
    let(:user_not_exist) { { uuid: 0 } }

    context 'when the request is valid' do
      before { post '/api/v1/users/verify', params: valid_attributes }
      it 'returns user verified' do
        expect(response.status).to eq(200)
      end
    end

    context 'when the pin is invalid' do
      before { post '/api/v1/users/verify', params: invalid_pin }
      it 'returns invalid pin' do
        res = JSON.parse(response.body)
        expect(res["status"]).to eq(400)
      end
    end

    context 'when the pin is invalid' do
      before { post '/api/v1/users/verify', params: pin_expired }
      it 'returns pin expired' do
        res = JSON.parse(response.body)
        expect(res["status"]).to eq(400)
      end
    end

    context 'when the user does not exist' do
      before { post '/api/v1/users/verify', params: user_not_exist }
      it 'returns user not exist' do
        res = JSON.parse(response.body)
        expect(res["status"]).to eq(400)
      end
    end

  end

  describe 'POST /v1/users/update' do
    let(:valid_attributes) {{ f_name: users.first.f_name, l_name: users.first.l_name, email: users.first.email, notification: users.first.notification, user_id: users.first.id }}
    let(:invalid_attributes) { { f_name: users.first.f_name, l_name: users.first.l_name, email: users.first.email, notification: users.first.notification, user_id: ''} }
    let(:user_not_exist) { { f_name: users.first.f_name, l_name: users.first.l_name, email: users.first.email, notification: users.first.notification, user_id: 0 } }

    context 'when the request is valid' do
      before { post '/api/v1/users/update', params: valid_attributes }
      it 'returns user updated' do
        expect(response.status).to eq(200)
      end
    end

    context 'when the user id is not mentioned' do
      before { post '/api/v1/users/update', params: invalid_attributes }
      it 'returns invalid user' do
        res = JSON.parse(response.body)
        expect(res["status"]).to eq(404)
      end
    end

    context 'when the user does not exist' do
      before { post '/api/v1/users/update', params: user_not_exist }
      it 'returns user not exist' do
        res = JSON.parse(response.body)
        expect(res["status"]).to eq(404)
      end
    end

  end
end