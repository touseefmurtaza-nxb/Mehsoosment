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

require 'rails_helper'

RSpec.describe Status, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
