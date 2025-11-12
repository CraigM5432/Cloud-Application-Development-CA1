class Task < ApplicationRecord
  validates :title, presence: true
  validates :priority, inclusion: { in: ["Low", "Medium", "High"], message: "%{value} is not a valid priority" }
end

