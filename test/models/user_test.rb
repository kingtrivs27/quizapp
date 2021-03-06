# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  email             :string(255)
#  phone             :string(255)
#  city              :string(255)
#  api_key           :string(255)
#  api_version       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  image_url         :string(255)
#  facebook_id       :string(255)
#  total_score       :integer          default(0), not null
#  total_quiz_played :integer          default(0), not null
#  won               :integer          default(0), not null
#  lost              :integer          default(0), not null
#  call_request_at   :datetime
#
# Indexes
#
#  index_users_on_api_key  (api_key) UNIQUE
#  index_users_on_email    (email)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
