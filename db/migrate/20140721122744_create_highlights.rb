class CreateHighlights < ActiveRecord::Migration
  def change
    create_table :highlights do |t|
      t.integer :stream_id, default: 0
      t.text :notes, default: ""
      t.timestamp :start_time
      t.timestamp :stop_time

      t.timestamps
    end
  end
end
