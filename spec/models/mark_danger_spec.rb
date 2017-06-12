# == Schema Information
#
# Table name: mark_dangers
#
#  id         :integer          not null, primary key
#  latitude   :float
#  longitude  :float
#  user_id    :integer
#  mark_type  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe MarkDanger, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
