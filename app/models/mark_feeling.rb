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

class MarkFeeling < ApplicationRecord

  # --------------------- model association ---------------------
	belongs_to :user

  # --------------------- validations ---------------------------
  validates_presence_of :latitude
  validates_presence_of :longitude
  validates_presence_of :user_id
  validates_presence_of :mark_type

  # --------------------- enumerable ----------------------------
  MARK_TYPE = {1=>'Happy',2=>'Sad', 3=>'Boring', 4=>'Angry'}

  # --------------------- geocoder -------------------------------
  reverse_geocoded_by :latitude, :longitude

  # --------------------- geokit -------------------------------
  acts_as_mappable :default_units => :miles,
                   # :default_formula => :sphere,
                   # :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
end
