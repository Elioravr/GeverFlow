class TasksController < ApplicationController
  respond_to :json

  def index
    respond_with view_model.select('tasks.*, users.username').joins(:user)
  end

  def show
    respond_with view_model.find(params[:id])
  end

  def create
    task = Task.new(params[:task])
    
    if task.save()
      respond_to do |format|
        format.json { render json: task, include: :user }
      end
    else
      respond_to do |format|
        format.json { render json: task.errors, status: :unprocessable_entity}
      end
    end
  end

  def update
    task = Task.find(params[:id])

    if task.update_attributes(params[:task])
      respond_to do |format|
        format.json { render json: task, include: :user }
      end
    else
      respond_to do |format|
        format.json { render json: task.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    respond_with Task.destroy(params[:id])
  end

  def view_model
    return Task.select('tasks.*, users.username').joins('LEFT OUTER JOIN users ON users.id = tasks.user_id')
  end
end
