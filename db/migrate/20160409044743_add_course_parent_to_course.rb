class AddCourseParentToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :course_parent, :integer, null: false
  end
end
