class AddAppVersionToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :appversion, :string
    add_column :users, :call_request_at, :datetime
  end
end
