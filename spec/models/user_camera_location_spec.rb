# == Schema Information
#
# Table name: user_camera_locations
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe UserCameraLocation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
