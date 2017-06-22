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

  class << self

    def get_registered_contacts(params)
      hsh = {}
      arr = []
      user = User.find_by(uuid: params[:uuid])
      own_number = user.phone_number
      contacts = JSON.parse params[:contacts]
      verified_users = User.verified.pluck(:phone_number)
      contacts.each do |contact|
        contact["phoneNumbers"].each do |number|
          number = number_format(number)
          if verified_users.include? number and (own_number != number)
            hsh[:contactName] = contact["contactName"]
            hsh[:phoneNumber] = number
            hash[:room] = get_room_key(own_number,number)
            arr << hsh
          end
        end
      end

    end

    def get_room_key(own_number,number)
      ids = User.where(phone_number: [own_number,number]).order("id").map(&:id)
      conversation = Conversation.where(user_id: ids.first,connection_id: ids.last).first
      "room-#{conversation.room_id}"
    end
  end

end
