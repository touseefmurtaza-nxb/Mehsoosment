# == Schema Information
#
# Table name: features
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Feature < ApplicationRecord
  has_many :feature_codes, dependent: :destroy
  belongs_to :user
end
