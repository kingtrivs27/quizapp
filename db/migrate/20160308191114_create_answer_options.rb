class CreateAnswerOptions < ActiveRecord::Migration
  def change
    create_table :answer_options do |t|
      t.integer :question_id, :null => false
      t.text    :description, :null => false
      t.boolean :is_correct, :default => false, :null => false

      t.timestamps null: false
    end
  end
end
