class AddReminderShownToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :reminder_shown, :boolean, default: false
  end
end
