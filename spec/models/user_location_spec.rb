require 'rails_helper'

RSpec.describe UserLocation, type: :model do

  # model association
  it { should belong_to(:user) }

  # validations
  it { should validate_presence_of(:latitude) }
  it { should validate_presence_of(:longitude) }
  it { should validate_presence_of(:user_id) }
end