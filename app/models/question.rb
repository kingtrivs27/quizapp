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

class Question < ActiveRecord::Base
  belongs_to :subject
  has_many :answer_options
end
