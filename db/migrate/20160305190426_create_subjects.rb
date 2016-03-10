class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :name, :null => false, :unique => true

      t.timestamps null: false
    end
  end
end
