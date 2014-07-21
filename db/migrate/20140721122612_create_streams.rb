class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|
      t.timestamp :start_time
      t.timestamp :stop_time

      t.timestamps
    end
  end
end
