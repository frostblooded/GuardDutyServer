# A controller which handles workers' actions
class WorkersController < ApplicationController
  autocomplete :worker, :name, full: true

  def autocomplete_worker_name
    site = Site.find params[:format]
    workers = Worker.where('name LIKE ? AND company_id=?', "#{params['term']}%", current_company.id)

    # Remove workers which already belong to this site
    workers -= site.workers

    result = workers.map do |worker|
      { id: worker.id,
        label: worker.name,
        value: worker.name }
    end

    render json: result
  end

  def index
    @workers = current_company.workers
  end

  def new
    @worker = Worker.new
  end

  def edit
    @worker = Worker.find params[:id]
  end

  def create
    @worker = Worker.new worker_params
    @worker.company = current_company

    if @worker.save
      flash[:success] = 'Worker created'
      redirect_to workers_path
    else
      render 'new'
    end
  end

  def update
    @worker = Worker.find params[:id]

    if @worker.update_attributes(worker_params)
      flash[:success] = 'Worker updated'
      redirect_to workers_path
    else
      render 'edit'
    end
  end

  def show
    @worker = Worker.find params[:id]

    # Set classes for the HTML tags from here
    @worker.activities.each { |a| a.row_class = get_row_class(a) }
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
