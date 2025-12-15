module Api
  module V1
    class TasksController < ApplicationController
      protect_from_forgery with: :null_session

      before_action :set_task, only: %i[show update destroy]

      def index
        render json: Task.all
      end

      def show
        render json: @task
      end

      def create
        @task = Task.new(task_params.except(:reminder_offset, :reminder_preset))

        if @task.save
          schedule_reminder(@task)
          render json: @task, status: :created
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @task.update(task_params.except(:reminder_offset, :reminder_preset))
          schedule_reminder(@task)
          render json: @task
        else
          render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @task.destroy
        head :no_content
      end

      private

      def set_task
        @task = Task.find(params[:id])
      end

      def task_params
        params.require(:task).permit(
          :title,
          :priority,
          :due_date,
          :completed,
          :reminder_offset,
          :reminder_preset
        )
      end

      def schedule_reminder(task)
        minutes =
          if params[:task][:reminder_preset].present?
            Task::REMINDER_PRESETS[params[:task][:reminder_preset]]
          else
            params[:task][:reminder_offset]&.to_i
          end

        return unless minutes && task.due_date

        reminder_time = task.due_date - minutes.minutes

        task.update_column(:reminder_at, reminder_time)

        TaskReminderJob
          .set(wait_until: reminder_time)
          .perform_later(task.id)
      end
    end
  end
end

