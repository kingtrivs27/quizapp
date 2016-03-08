class AddColumnImageUrlToUsers < ActiveRecord::Migration
  def change
    add_column :users, :image_url, :string, default: nil
  end
end
