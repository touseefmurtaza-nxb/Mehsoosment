require 'rails_helper'

RSpec.describe 'Users API', type: :request do

  describe 'POST /api/v1/users' do

    let(:valid_attributes) { { phone_number: '03354435636' } }
    context 'when the request is valid' do
      before { post '/api/v1/users', params: valid_attributes }

      it 'creates a user' do
        # expect(response.status).to eq(200)
        expect(response.status).to eq(200)
      end
    end

  end

end



