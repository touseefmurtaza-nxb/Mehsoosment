# == Schema Information
#
# Table name: users
#
#  id           :integer          not null, primary key
#  phone_number :string
#  pin          :string
#  verified     :boolean
#  uuid         :string
#  expires_at   :datetime
#  f_name       :string
#  l_name       :string
#  email        :string
#  notification :boolean          default("true")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  distance     :float            default("20.0")
#

require 'rails_helper'

RSpec.describe User, type: :model do

  # model association
  it { should have_many(:mark_feelings).dependent(:destroy) }
  it { should have_many(:user_locations).dependent(:destroy) }
  it { should have_one(:device).dependent(:destroy) }

  # validations
  it { should validate_presence_of(:phone_number) }
end
