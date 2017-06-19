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

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: ""
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  def set_expiry
    self.expires_at = self.created_at + 24.hour
    self.save
    self.delay(run_at: 1.minutes.from_now).destroy_status
  end

  def destroy_status
    send_notification
    self.destroy
  end

  def send_notification
    if self.user.device.device_type.eql?("android")
      fcm = FCM.new(ENV['FCM_API_KEY'])
      options = {:data => {:body => "Status has been destroyed", :title => "status destroyed"}}
      response = fcm.send(registration_ids, options)
    elsif self.user.device.device_type.eql?("iOS")
      APNS.send_notification(device_token, :@alert => "Status has been destroyed", :badge => 1, :sound => 'default')
    end
  end

end
