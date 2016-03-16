class AddSubjectParentIdToSubject < ActiveRecord::Migration
  def change
    add_column :subjects, :subject_parent_id, :integer, :null => false
  end
end
