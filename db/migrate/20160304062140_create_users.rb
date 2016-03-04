class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :city
      t.string :api_key
      t.integer :api_version
      t.timestamps null: false
    end
  end
end
