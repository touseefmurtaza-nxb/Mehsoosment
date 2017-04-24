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

class Device < ApplicationRecord

	# --------------------- model association ---------------------
	belongs_to :user

	# --------------------- validations ---------------------------
	validates_presence_of :device_token
	validates_presence_of :device_type
	validates_presence_of :user_id
end
