# == Schema Information
#
# Table name: feature_codes
#
#  id         :integer          not null, primary key
#  code       :string
#  feature_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe FeatureCode, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
