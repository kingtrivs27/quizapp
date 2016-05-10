# == Schema Information
#
# Table name: devices
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  user_device_id :string(255)
#  google_api_key :text(65535)
#  android_id     :text(65535)
#  serial_number  :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  appversion     :string(255)
#
# Indexes
#
#  index_devices_on_user_device_id  (user_device_id)
#  index_devices_on_user_id         (user_id)
#

require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
