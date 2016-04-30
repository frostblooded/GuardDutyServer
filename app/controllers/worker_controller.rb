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

  def create
    @worker = current_company.workers.create(worker_params)
    if @worker.save
      redirect_to workers_path, :notice => "Signed up!"
    else
      render "new"
    end
  end

  def show
    @worker = Worker.find_by(@worker)
  end

  private

  def worker_params
    params.require(:worker).permit(:first_name, :last_name, :password, :password_confirmation)
  end
end
