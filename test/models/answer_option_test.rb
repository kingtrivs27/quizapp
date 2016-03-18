# == Schema Information
#
# Table name: answer_options
#
#  id          :integer          not null, primary key
#  question_id :integer          not null
#  description :text(65535)      not null
#  is_correct  :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_answer_options_on_question_id  (question_id)
#

require 'test_helper'

class AnswerOptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
