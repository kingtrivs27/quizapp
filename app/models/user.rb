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
#  facebook_id :string(255)
#

class User < ActiveRecord::Base
  before_create :set_api_key

  has_many :devices


    private
    def set_api_key
      return if api_key.present?
      self.api_key = generated_api_key
    end

    def generated_api_key
      SecureRandom.uuid.gsub(/\-/,'')
    end
end
