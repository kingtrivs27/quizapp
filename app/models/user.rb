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
#
# Indexes
#
#  index_users_on_api_key  (api_key) UNIQUE
#  index_users_on_email    (email)
#

class User < ActiveRecord::Base
  before_create :set_api_key

  has_many :devices

    def update_game_profile(score, won_flag)
      self.total_score += (score.to_s.to_i)
      self.total_quiz_played += 1
      if won_flag
        self.won += 1
      else
        self.lost += 1
      end

      self.save!
    end

    private
    def set_api_key
      return if api_key.present?
      self.api_key = generated_api_key
    end

    def generated_api_key
      SecureRandom.uuid.gsub(/\-/,'')
    end
end
