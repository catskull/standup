class ModifyEvents < ActiveRecord::Migration[5.1]
  def change
    remove_column :events, :owner
    remove_column :events, :status
    remove_column :events, :standing
    add_column    :events, :ended_at, :datetime
  end
end
