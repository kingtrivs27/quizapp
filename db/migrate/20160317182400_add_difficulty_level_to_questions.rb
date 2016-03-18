class AddDifficultyLevelToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :level, :integer, :null => false
  end
end
