import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overTime", "byPriority"]

  connect() {
    this.loadCharts()
  }

  async loadCharts() {
    const response = await fetch("/api/v1/tasks")
    const tasks = await response.json()

    this.renderTasksOverTime(tasks)
    this.renderTasksByPriority(tasks)
  }

  renderTasksOverTime(tasks) {
    const counts = {}

    tasks.forEach(task => {
      const day = task.created_at.split("T")[0]
      counts[day] = (counts[day] || 0) + 1
    })

    new Chart(this.overTimeTarget, {
      type: "line",
      data: {
        labels: Object.keys(counts),
        datasets: [{
          label: "Tasks Created",
          data: Object.values(counts),
          borderColor: "#0d6efd",
          fill: false
        }]
      }
    })
  }

  renderTasksByPriority(tasks) {
    const counts = {}

    tasks.forEach(task => {
      counts[task.priority] = (counts[task.priority] || 0) + 1
    })

    new Chart(this.byPriorityTarget, {
      type: "pie",
      data: {
        labels: Object.keys(counts),
        datasets: [{
          data: Object.values(counts),
          backgroundColor: ["#ffc107", "#0dcaf0", "#dc3545"]
        }]
      }
    })
  }
}

