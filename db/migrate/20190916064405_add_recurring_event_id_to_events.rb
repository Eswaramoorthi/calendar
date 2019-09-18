class AddRecurringEventIdToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :recurring_event_id, :integer
  end
end
