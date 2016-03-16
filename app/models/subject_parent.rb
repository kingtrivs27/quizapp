# == Schema Information
#
# Table name: subject_parents
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  course_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Note: This entity is called as 'Subject' in UI
class SubjectParent < ActiveRecord::Base
  has_many :subjects
  belongs_to  :course
end
