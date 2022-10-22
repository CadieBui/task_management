class TasksController < ApplicationController
  before_action :find_task, only: %i[ show edit update destroy ]

  # GET /tasks or /tasks.json
  def index
    # TODO: show and search data from Task table 
    @q = Task.ransack(params[:q])
    @tasks = @q.result(distinct: true)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
    #TODO: find and show single task
    @tasks = Task.find(params[:id])

    respond_to do |format|
      format.html  # show.html.erb
      format.json  { render :json => @tasks }
    end
  end

  # GET /tasks/new
  def new
    # TODO: display the create a new task page
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
    # TODO: edit a single task
    @task = Task.find(params[:id])
  end

  # POST /tasks or /tasks.json
  def create
    # TODO: after press submit button => create a new task
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to task_url(@task), notice: t('forms.create.success') }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    # TODO: after press submit button => update a single task 
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to task_url(@task), notice: t('forms.edit.success') }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    # TODO: delete a single task
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: t('forms.delete.success') }
      format.json { head :no_content }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def find_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :content, :endtime, :task_status)
    end
end
