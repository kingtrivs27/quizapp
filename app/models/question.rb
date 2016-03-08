# == Schema Information
#
# Table name: questions
#
#  id          :integer          not null, primary key
#  subject_id  :integer          not null
#  description :text(65535)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Question < ActiveRecord::Base
end
