require "test_helper"

class TaskWorkflowTest < ActionDispatch::IntegrationTest
  test "can create a new task" do
    # Visiting the new task page
    get new_task_path
    assert_response :success

    # Submiting the form (simulating user creation)
    post tasks_path, params: {
      task: {
        title: "Integration Test Task",
        description: "Testing create workflow",
        priority: "High",
        due_date: Time.now + 2.days,
        completed: false
      }
    }

    # Following the redirect after creation
    follow_redirect!
    assert_response :success

    # Confirming task appears on index page
    assert_match "Integration Test Task", response.body
  end

  test "can update an existing task" do
    # Using the first task in the database
    task = Task.create!(
      title: "Old Title",
      priority: "Low",
      completed: false
    )

    # Updating the task
    patch task_path(task), params: {
      task: { title: "Updated Title", completed: true }
    }

    # Following the redirect
    follow_redirect!
    assert_response :success

    # Confirming changes persisted
    task.reload
    assert_equal "Updated Title", task.title
    assert task.completed, "Task should be marked completed"
  end
end

