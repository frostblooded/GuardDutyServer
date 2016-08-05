class WorkerController < ApplicationController
  def index
    if current_company
      @company = current_company
      @worker = @company.workers
    end
  end

  def new
    @worker = Worker.new
  end

  def edit
    @worker = Worker.find(params[:id])
  end

  def create
    @worker = current_company.workers.create(worker_params)
    if @worker.save
      redirect_to workers_path, :notice => "Signed up!"
    else
      render "new"
    end
  end

  def update
    @worker = Worker.find(params[:id])
    if params[:call_length].present?
      @worker.settings(:call).interval = params[:call_interval]
      @worker.settings(:call).save!

      flash[:success] = "Settings saved"
      redirect_to worker_path

    elsif @worker.update_attributes(worker_params)
      redirect_to workers_path, :notice => "Changes saved!"
    elsif 
      render 'edit'
    end
  end

  def show
    @company = current_company 
    @worker = Worker.find(params[:id])
    @activities = @worker.activities
    @call_length = params[:call_length]
    @company.settings(:mail).daily
  end

  def destroy
    Worker.find(params[:id]).destroy
    flash[:success] = "Worker deleted"
    redirect_to workers_path
  end

  private

  def worker_params
    params.require(:worker).permit(:name, :password, :password_confirmation)
  end
end
