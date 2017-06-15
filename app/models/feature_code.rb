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

class FeatureCode < ApplicationRecord
  belongs_to :feature

  def generate_code
    self.code = loop do
      random_token = SecureRandom.hex(2)
      break random_token unless FeatureCode.exists?(code: random_token)
    end
  end

end
