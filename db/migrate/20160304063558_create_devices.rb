class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.belongs_to :user, index:true
      t.string :user_device_id
      t.text :google_api_key
      t.text :android_id
      t.string :serial_number

      t.timestamps null: false
    end
  end
end
