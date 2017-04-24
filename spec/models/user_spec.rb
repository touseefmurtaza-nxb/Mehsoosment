require 'rails_helper'

RSpec.describe User, type: :model do

  # model association
  it { should have_many(:mark_feelings).dependent(:destroy) }
  it { should have_many(:user_locations).dependent(:destroy) }
  it { should have_one(:device).dependent(:destroy) }

  # validations
  it { should validate_presence_of(:phone_number) }
end