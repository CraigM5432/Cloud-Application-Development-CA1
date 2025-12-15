class AddReminderJobIdToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :reminder_job_id, :string
  end
end
