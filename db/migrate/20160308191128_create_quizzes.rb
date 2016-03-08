class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.integer :subject_id, :null => false
      t.integer :requester_id, :null => false
      t.integer :opponent_id, :null => false

      t.integer :requester_score, :default => 0
      t.integer :opponent_score, :default => 0

      t.boolean :requester_available, :default => true
      t.boolean :opponent_available, :default => true

      # needed when opponent is a bot
      t.string :opponent_type, :default => ''

      # pending, started, finished
      t.string :status,  :limit => 25

      t.timestamps null: false
    end
  end
end
