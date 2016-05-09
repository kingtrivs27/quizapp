class CreateSubjectParents < ActiveRecord::Migration
  def change
    create_table :subject_parents, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :name, :null => false
      t.integer :course_id, :null => false

      t.timestamps null: false
    end
  end
end
