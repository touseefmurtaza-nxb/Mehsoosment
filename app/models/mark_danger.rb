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

class MarkDanger < ApplicationRecord
  belongs_to :user
  MARK_TYPE = {1=>'Camera',2=>'Challan', 3=>'Naaka', 4=>'Crime'}

  reverse_geocoded_by :latitude, :longitude
  # after_validation :reverse_geocode

  def user_status
    status = user.try(:statuses).try(:last)
    {:status_id => status.id, :status_text => status.status_text, :image_url => "http://mehsoosment.vteamslabs.com/" + status.image.url } if status
  end
end
