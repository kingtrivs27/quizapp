class AddColumnScoreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_score, :integer, null: false, default: 0
    add_column :users, :total_quiz_played, :integer, null: false, default: 0
    add_column :users, :won, :integer, null: false, default: 0
    add_column :users, :lost, :integer, null: false, default: 0
  end
end
