# == Schema Information
#
# Table name: quizzes
#
#  id              :integer          not null, primary key
#  requestor_id    :integer          not null
#  opponent_id     :integer          not null
#  requestor_score :integer          default(0)
#  opponent_score  :integer          default(0)
#  opponent_type   :string(255)      default("")
#  status          :string(25)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Quiz < ActiveRecord::Base
end
