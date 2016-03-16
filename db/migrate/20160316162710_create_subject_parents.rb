class CreateSubjectParents < ActiveRecord::Migration
  def change
    create_table :subject_parents do |t|
      t.string :name, :null => false
      t.integer :course_id, :null => false

      t.timestamps null: false
    end
  end
end
