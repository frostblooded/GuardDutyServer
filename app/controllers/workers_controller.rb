# A controller which handles workers' actions
class WorkersController < ApplicationController
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
    @worker = Worker.new(worker_params)
    @worker.company = current_company

    if @worker.save
      redirect_to workers_path, notice: 'Worker created!'
    else
      render 'new'
    end
  end

  def update
    @worker = Worker.find(params[:id])

    if @worker.update_attributes(worker_params)
      redirect_to workers_path, notice: 'Changes saved!'
    else
      render 'edit'
    end
  end

  def show
    @company = current_company
    @worker = Worker.find(params[:id])
    @activities = @worker.activities
    @call_length = params[:call_length]
    @company.settings(:email).daily

    # Set classes for the HTML tags from here
    @activities.each { |a| a.row_class = get_row_class(a) }
  end

  def destroy
    Worker.find(params[:id]).destroy
    flash[:success] = 'Worker deleted'
    redirect_to workers_path
  end

  private

  def worker_params
    params.require(:worker).permit(:name, :password, :password_confirmation)
  end

  def get_row_class(activity)
    row_class = ''

    if activity.call?
      row_class = (activity.time_left.nonzero? ? 'answered' : 'unanswered')
      row_class += '_call_activity'
    elsif activity.login?
      row_class = 'login_activity'
    elsif activity.logout?
      row_class = 'logout_activity'
    end

    row_class
  end
end
