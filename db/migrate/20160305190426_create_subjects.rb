class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.string :name, :null => false, :unique => true

      t.timestamps null: false
    end
  end
end
