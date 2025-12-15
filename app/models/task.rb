class Task < ApplicationRecord
  
  REMINDER_PRESETS = {
    "15_minutes" => 15,
    "1_hour"     => 60,
    "24_hours"   => 1440
  }.freeze
  
  validates :title, presence: true
  validates :priority, inclusion: { in: ["Low", "Medium", "High"], message: "%{value} is not a valid priority" }
  attr_accessor :reminder_offset
  
  after_update :cancel_reminder_if_completed

  private

  def cancel_reminder_if_completed
    return unless saved_change_to_completed? && completed?

    cancel_existing_reminder
    update_column(:reminder_at, nil)
  end

  def cancel_existing_reminder
    return if reminder_job_id.blank?

    Sidekiq::ScheduledSet.new.find_job(reminder_job_id)&.delete
    update_column(:reminder_job_id, nil)
  end

end

