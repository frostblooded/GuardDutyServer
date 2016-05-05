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

  def show
    @company = current_company
    @worker = Worker.find(params[:id])
    @calls = @worker.calls
  end

  def destroy
    Worker.find(params[:id]).destroy
    flash[:success] = "Worker deleted"
    redirect_to workers_path
  end  

  private

  def worker_params
    params.require(:worker).permit(:first_name, :last_name, :password, :password_confirmation)
  end
end
