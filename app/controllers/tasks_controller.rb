class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks
  def index
    @tasks = Task.all

    case params[:sort]
    when "priority"
      @tasks = @tasks.order(priority: :asc)
    when "due_date"
      @tasks = @tasks.order(due_date: :asc)
    when "completed"
      @tasks = @tasks.order(completed: :asc)
    end
  end

  # GET /tasks/1
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        schedule_reminder(@task)   

        format.html { redirect_to @task, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  def update
    respond_to do |format|
      if @task.update(task_params)
        schedule_reminder(@task)   

        format.html { redirect_to @task, notice: "Task was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_path, notice: "Task was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

    def set_task
      @task = Task.find(params.require(:id))
    end

    def task_params
    	params.require(:task).permit(
    	:title,
    	:description,
    	:priority,
    	:due_date,
    	:completed,
    	:reminder_offset)
    end

    def schedule_reminder(task)
  	return if params[:task][:reminder_offset].blank?
  	return if task.completed?

  	minutes = params[:task][:reminder_offset].to_i
  	reminder_time = task.due_date - minutes.minutes

  	# Canceling existing reminder if present
  	if task.reminder_job_id.present?
    	Sidekiq::ScheduledSet.new.find_job(task.reminder_job_id)&.delete
  	end

  	job = TaskReminderJob.set(wait_until: reminder_time).perform_later(task.id)

  	task.update_columns(reminder_at: reminder_time,reminder_job_id: job.provider_job_id)
	end

end
