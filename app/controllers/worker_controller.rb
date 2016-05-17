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
      @call_length = params[:call_length]

      @worker.settings(:call_length).call_length = @call_length
      @worker.settings(:call_length).save!

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
    @calls = @worker.calls
    @call_length = params[:call_length]
    @company.settings(:daily_mail).daily_mail
    @company.settings(:shift_start).shift_start
    @company.settings(:shift_end).shift_end
    @worker.settings(:call_length).call_length


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
