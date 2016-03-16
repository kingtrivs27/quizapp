# == Schema Information
#
# Table name: subjects
#
#  id                :integer          not null, primary key
#  name              :string(255)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  subject_parent_id :integer          not null
#

# Note: entity is called as 'Topic' in UI
class Subject < ActiveRecord::Base
  has_many :questions
  has_many :quizzes, class_name: :Quiz
end
