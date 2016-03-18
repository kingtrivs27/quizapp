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

class AnswerOption < ActiveRecord::Base
  belongs_to :answer
end
