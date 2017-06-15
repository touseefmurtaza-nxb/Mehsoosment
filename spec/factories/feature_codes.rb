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

FactoryGirl.define do
  factory :feature_code do
    code "MyString"
    feature_id 1
  end
end
