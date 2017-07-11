# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  phone_number    :string
#  pin             :string
#  verified        :boolean
#  uuid            :string
#  expires_at      :datetime
#  f_name          :string
#  l_name          :string
#  email           :string
#  notification    :boolean          default("true")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  distance        :float            default("20.0")
#  name            :string
#  password_digest :string
#

class User < ApplicationRecord
  # has_secure_password
  require 'securerandom'

  # --------------------- model association ---------------------
  has_many :mark_dangers, dependent: :destroy
  has_many :mark_feelings, dependent: :destroy
  has_many :user_locations, dependent: :destroy
  has_many :user_camera_locations, dependent: :destroy
  has_one :device, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :features
  has_many :conversations

  # --------------------- validations ---------------------
  validates_presence_of :phone_number
  validates_format_of :email, :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/, on: :update
  validates :email, presence: true, on: :update
  validates :f_name, presence: true, on: :update
  validates :l_name, presence: true, on: :update

  # --------------------- scope ---------------------
  scope :verified, -> { where(verified: true) }


  # --------------------- model Methods ---------------------
  def generate_pin
    self.pin = rand(0000..9999).to_s.rjust(4, "0")
    self.uuid ||= SecureRandom.uuid
    self.verified = nil
    self.expires_at = (Time.zone.now + 30.minute)
    self.save!
  end
  def twilio_client
    Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end
  def send_pin
    # begin
    twilio_client.messages.create(
      to: phone_number,
      from: ENV['TWILIO_PHONE_NUMBER'],
      body: "Your PIN is #{pin}"
    )
    # rescue Twilio::REST::RequestError => e
    #   puts e.message
    # end
  end
  def verify(entered_pin)
    self.verified = nil
    self.save
    if (self.pin == entered_pin) and !self.expired?
      update(verified: true)
    end
  end
  def allow_notifications?
    self.notification
  end
  def expired?
    Time.zone.now > self.expires_at
  end
  def name
    "#{f_name} #{l_name}"
  end

  class << self
    def get_room_key(uuid,number)
      user = User.find_by_uuid(uuid)
      user_id = User.find_by_phone_number(number).id
      conversation = get_conversation(user,user_id)
      "room-#{conversation.room_id}"
    end
  end

end
