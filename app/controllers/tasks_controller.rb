class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in
  
  def index
    @tasks = current_user.tasks.all.page(params[:page]).per(10)
  end

  def show
    @task = set_task
    check_task(@task)
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = 'タスクが正常に投稿されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが投稿されませんでした'
      render :new
    end
  end

  def edit
    @task = set_task
    check_task(@task)
  end

  def update
    @task = set_task
    check_task(@task)

    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクは更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task = set_task
    check_task(@task)
    @task.destroy

    flash[:success] = 'タスクは正常に削除されました'
    redirect_to root_path
  end
  
  private
  
  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def set_task
    current_user.tasks.find_by_id(params[:id])
  end
  
  def check_task(task)
    unless task
      flash[:danger] = 'タスクが見つかりませんでした'
      redirect_to root_path
    end
  end
end
