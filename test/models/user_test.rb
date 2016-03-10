# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  email       :string(255)
#  phone       :string(255)
#  city        :string(255)
#  api_key     :string(255)
#  api_version :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  image_url   :string(255)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
