class TaskReminderJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = Task.find_by(id: task_id)
    return unless task
    return if task.completed?

    Rails.logger.info "Reminder: Task '#{task.title}' is due soon!"
  end
end

