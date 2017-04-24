# == Schema Information
#
# Table name: mark_feelings
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  user_id    :integer
#  mark_type  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class MarkFeelingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
