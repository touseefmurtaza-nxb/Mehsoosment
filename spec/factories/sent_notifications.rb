# == Schema Information
#
# Table name: sent_notifications
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  marker_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :sent_notification do
    user_id 1
    marker_id 1
  end
end
