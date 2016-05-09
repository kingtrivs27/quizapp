class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :name, :null => false

      t.timestamps null: false
    end
  end
end
