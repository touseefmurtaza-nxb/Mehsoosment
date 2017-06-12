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

class Status < ApplicationRecord
  belongs_to :user

  after_create :set_expiry

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def set_expiry
    self.expires_at = self.created_at + 24.hour
    self.save
  end
end
