require 'rails_helper'

RSpec.describe MarkFeeling, type: :model do

  # model association
  it { should belong_to(:user) }

  # validations
  it { should validate_presence_of(:latitude) }
  it { should validate_presence_of(:longitude) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:mark_type) }
end