class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :subject_id, :null => false
      t.text :description, :null => false
      # t.boolean :is_question, :default => true, :null => false

      t.timestamps null: false
    end
  end
end
