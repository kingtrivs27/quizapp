# == Schema Information
#
# Table name: courses
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  course_parent :integer          not null
#

class Course < ActiveRecord::Base
  has_many :subject_parents
  enum course_parent: {ca_cpt: 1, cs_foundation: 2}

end
