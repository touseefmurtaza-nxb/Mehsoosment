# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Room < ApplicationRecord
  has_many :conversations
  has_many :messages

  def last_message
    messages.last.as_json(include: [:sender,:receiver])
  end
end
