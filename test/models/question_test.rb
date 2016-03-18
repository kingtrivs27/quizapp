# == Schema Information
#
# Table name: questions
#
#  id          :integer          not null, primary key
#  subject_id  :integer          not null
#  description :text(65535)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  level       :integer          not null
#
# Indexes
#
#  index_questions_on_level       (level)
#  index_questions_on_subject_id  (subject_id)
#

require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
