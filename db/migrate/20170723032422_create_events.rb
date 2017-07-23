class CreateEvents < ActiveRecord::Migration[5.1]
  def self.up
    create_table :events do |t|
      t.string :owner
      t.string :status
      t.boolean :standing
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
