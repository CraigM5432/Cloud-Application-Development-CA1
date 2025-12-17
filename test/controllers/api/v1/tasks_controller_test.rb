require "test_helper"

class Api::V1::TasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_tasks_path
    assert_response :success
    assert_match "application/json", response.content_type
  end

  test "should create task via API" do
    assert_difference("Task.count", 1) do
      post api_v1_tasks_path, params: {
        task: {
          title: "API Test Task",
          priority: "High",
          due_date: Time.now + 1.day
        }
      }, as: :json
    end

    assert_response :success
  end
end

