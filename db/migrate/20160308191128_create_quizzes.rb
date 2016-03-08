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
      # user => 0, bot => 1
      t.integer :opponent_type, default: 0

      # pending => 0, started => 1, finished => 3
      t.integer :status, default: 0
      t.text :info, null: true

      t.timestamps null: false
    end
  end
end
