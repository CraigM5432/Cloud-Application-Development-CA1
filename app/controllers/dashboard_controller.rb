class DashboardController < ApplicationController
  def index
    @total_tasks = Task.count
    @completed_tasks = Task.where(completed: true).count
    @pending_tasks = Task.where(completed: false).count
    @completion_rate = @total_tasks.zero? ? 0 : ((@completed_tasks.to_f / @total_tasks) * 100).round(2)

    # Tasks created over time (for charts)
    @tasks_by_day = Task.group_by_day(:created_at).count

    # Tasks grouped by priority
    @tasks_by_priority = Task.group(:priority).count
  end
end

