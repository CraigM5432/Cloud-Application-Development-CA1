require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  test "creating a new task" do
    # Step 1: Visit the Tasks index page
    visit tasks_url
    assert_selector "h1", text: "Tasks"

    # Step 2: Click 'New task'
    click_on "New task"

    # Step 3: Fill in the form
    fill_in "Title", with: "System Test Task"
    fill_in "Description", with: "Created through system test"
    select "Medium", from: "Priority"
    click_on "Create Task"

    # Step 4: Verify the task appears on the page
    assert_text "System Test Task"
  end

  test "updating a task" do
    # Create a task first
    Task.create!(title: "Old Title", priority: "Low")

    # Step 1: Visit the Tasks index page
    visit tasks_url
    click_on "Edit", match: :first

    # Step 2: Update the task title
    fill_in "Title", with: "Updated Title"
    click_on "Update Task"

    # Step 3: Confirm the change
    assert_text "Updated Title"
  end
end

