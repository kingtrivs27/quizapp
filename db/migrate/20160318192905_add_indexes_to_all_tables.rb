class AddIndexesToAllTables < ActiveRecord::Migration
  def change
    add_index :answer_options, :question_id
    add_index :devices, :user_device_id
    add_index :questions, :subject_id
    add_index :questions, :level

    add_index :quizzes, [:subject_id, :status]
    add_index :quizzes, :created_at

    add_index :subject_parents, :course_id
    add_index :subjects, :subject_parent_id

    add_index :users, :api_key, unique: true
    add_index :users, :email



  end
end
