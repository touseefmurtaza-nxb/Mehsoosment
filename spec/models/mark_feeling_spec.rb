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
