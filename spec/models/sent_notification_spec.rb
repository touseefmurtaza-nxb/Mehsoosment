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

require 'rails_helper'

RSpec.describe SentNotification, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
