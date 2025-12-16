class TaskReminderJob < ApplicationJob
  queue_as :default

  def perform(task_id)
  task = Task.find_by(id: task_id)
  return unless task
  return if task.completed?

  task.update!(
    reminded_at: Time.current,
    reminder_shown: false
  )

  Rails.logger.info "Reminder fired for task: #{task.title}"
 end
end

