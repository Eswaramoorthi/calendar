class AddEndDateToRecurringEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :recurring_events, :end_date, :date
  end
end
