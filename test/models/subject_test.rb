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
# Indexes
#
#  index_subjects_on_subject_parent_id  (subject_parent_id)
#

require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
