# == Schema Information
#
# Table name: quizzes
#
#  id                  :integer          not null, primary key
#  subject_id          :integer          not null
#  requester_id        :integer          not null
#  opponent_id         :integer
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
# Indexes
#
#  index_quizzes_on_created_at             (created_at)
#  index_quizzes_on_subject_id_and_status  (subject_id,status)
#

require 'test_helper'

class QuizTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
