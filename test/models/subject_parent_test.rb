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
# Indexes
#
#  index_subject_parents_on_course_id  (course_id)
#

require 'test_helper'

class SubjectParentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
