# == Schema Information
#
# Table name: quizzes
#
#  id                  :integer          not null, primary key
#  subject_id          :integer          not null
#  requester_id        :integer          not null
#  opponent_id         :integer          not null
#  requester_score     :integer          default(0)
#  opponent_score      :integer          default(0)
#  requester_available :boolean          default(TRUE)
#  opponent_available  :boolean          default(TRUE)
#  opponent_type       :integer          default(0)
#  status              :integer          default(0)
#  info                :text(65535)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Quiz < ActiveRecord::Base
  belongs_to :subject
  enum status: {pending: 0, started: 1, finished: 2}
  enum opponent_type: {user: 0, bot: 1}


end
