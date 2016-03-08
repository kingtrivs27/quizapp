class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.integer :requestor_id, :null => false
      t.integer :opponent_id, :null => false

      t.integer :requestor_score, :default => 0
      t.integer :opponent_score, :default => 0

      # needed when opponent is a bot
      t.string :opponent_type, :default => ''

      # pending, started, finished
      t.string :status,  :limit => 25

      t.timestamps null: false
    end
  end
end
