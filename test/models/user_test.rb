# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  phone_number    :string
#  pin             :string
#  verified        :boolean
#  uuid            :string
#  expires_at      :datetime
#  f_name          :string
#  l_name          :string
#  email           :string
#  notification    :boolean          default("true")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  distance        :float            default("20.0")
#  name            :string
#  password_digest :string
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
