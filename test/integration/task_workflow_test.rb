require "test_helper"

class TaskWorkflowTest < ActionDispatch::IntegrationTest
  test "can create a new task" do
    # Step 1: Visit the new task page
    get new_task_path
    assert_response :success

    # Step 2: Submit the form (simulate user creating a task)
    post tasks_path, params: {
      task: {
        title: "Integration Test Task",
        description: "Testing create workflow",
        priority: "High",
        due_date: Time.now + 2.days,
        completed: false
      }
    }

    # Step 3: Follow the redirect after creation
    follow_redirect!
    assert_response :success

    # Step 4: Confirm task appears on index page
    assert_match "Integration Test Task", response.body
  end

  test "can update an existing task" do
    # Use the first task in the database (from fixtures or create one inline)
    task = Task.create!(
      title: "Old Title",
      priority: "Low",
      completed: false
    )

    # Step 1: Update the task
    patch task_path(task), params: {
      task: { title: "Updated Title", completed: true }
    }

    # Step 2: Follow the redirect
    follow_redirect!
    assert_response :success

    # Step 3: Confirm changes persisted
    task.reload
    assert_equal "Updated Title", task.title
    assert task.completed, "Task should be marked completed"
  end
end

