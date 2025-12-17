require "test_helper"

class TaskReminderJobTest < ActiveJob::TestCase
  test "job runs without error" do
    task = Task.create!(
      title: "Reminder Test",
      priority: "High",
      due_date: Time.now + 1.hour
    )

    assert_nothing_raised do
      TaskReminderJob.perform_now(task.id)
    end
  end
end

