# == Schema Information
#
# Table name: user_locations
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserLocation < ApplicationRecord

	# --------------------- model association ---------------------
	belongs_to :user

	# --------------------- validations ---------------------
	validates_presence_of :latitude
	validates_presence_of :longitude
	validates_presence_of :user_id
end
