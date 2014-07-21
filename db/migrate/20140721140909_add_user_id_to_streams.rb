class AddUserIdToStreams < ActiveRecord::Migration
  def change
    add_column :streams, :user_id, :integer
  end
end
