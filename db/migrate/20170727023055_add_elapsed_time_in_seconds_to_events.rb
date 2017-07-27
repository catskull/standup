class AddElapsedTimeInSecondsToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :elapsed_time_in_seconds, :integer
  end
end
