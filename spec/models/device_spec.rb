# == Schema Information
#
# Table name: devices
#
#  id           :integer          not null, primary key
#  device_token :string
#  device_type  :string
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Device, type: :model do

  # model association
  it { should belong_to(:user) }

  # validations
  it { should validate_presence_of(:device_token) }
  it { should validate_presence_of(:device_type) }
  it { should validate_presence_of(:user_id) }
end
