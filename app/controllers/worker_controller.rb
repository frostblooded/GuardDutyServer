class WorkerController < ApplicationController
	def show
    #@company = Company.all
    #@worker = @company.workers.show
    @worker = Worker.all
  end

  def new
    @worker = Worker.new
  end

  def create
    #company = Company.new
    #worker = @company.workers.create(worker_params)
    @worker = Worker.create(worker_params)
    if @worker.save
      redirect_to workers_path, :notice => "Signed up!"
    else
      render "new"
    end
  end

  private

  def worker_params
    params.require(:worker).permit(:first_name, :last_name, :password, :password_confirmation)
  end
end
