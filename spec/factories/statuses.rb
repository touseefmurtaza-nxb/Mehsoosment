# == Schema Information
#
# Table name: statuses
#
#  id                 :integer          not null, primary key
#  status_text        :string
#  user_id            :integer
#  expires_at         :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#

FactoryGirl.define do
  factory :status do
    status_text "MyString"
    user_id 1
    expires_at "2017-06-08 15:43:58"
  end
end
