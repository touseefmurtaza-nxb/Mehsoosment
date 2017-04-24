require 'rails_helper'

RSpec.describe Device, type: :model do

  # model association
  it { should belong_to(:user) }

  # validations
  it { should validate_presence_of(:device_token) }
  it { should validate_presence_of(:device_type) }
  it { should validate_presence_of(:user_id) }
end