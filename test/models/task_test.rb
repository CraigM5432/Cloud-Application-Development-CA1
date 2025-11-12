require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @task = Task.new(title: "Test Task", priority: "High", completed: false)
  end

  test "valid task should save" do
    assert @task.save
  end

  test "task must have a title" do
    @task.title = nil
    assert_not @task.save, "Saved the task without a title"
  end

  test "priority must be valid" do
    @task.priority = "Invalid"
    assert_not @task.valid?, "Task accepted invalid priority"
  end
end

