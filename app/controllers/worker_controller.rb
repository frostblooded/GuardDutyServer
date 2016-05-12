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
    if @worker.update_attributes(worker_params)
      redirect_to workers_path, :notice => "Changes saved!"
    else
      render 'edit'
    end
  end

  def show
    @company = current_company 
    @worker = Worker.find(params[:id])
    @calls = @worker.calls
    @company.settings(:daily_mail).daily_mail
    @company.settings(:shift_start).shift_start
    @company.settings(:shift_end).shift_end
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
