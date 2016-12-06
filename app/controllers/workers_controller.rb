# A controller which handles workers' actions
class WorkersController < ApplicationController
  load_and_authorize_resource

  autocomplete :worker, :name, full: true

  def autocomplete_worker_name
    site = Site.find params[:format]
    workers = Worker.where('name LIKE ? AND company_id=?',
                           "#{params['term']}%", current_company.id)

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
    @workers = current_company.workers.paginate page: params[:page]
  end

  def new
  end

  def edit
  end

  def create
    @worker.company = current_company

    if @worker.save
      flash[:success] = t '.success'
      redirect_to workers_path
    else
      render 'new'
    end
  end

  def update
    if @worker.update_attributes(worker_params)
      flash[:success] = t '.success'
      redirect_to workers_path
    else
      render 'edit'
    end
  end

  def show
    # Set classes for the HTML tags from here
    @activities = @worker.activities
    @activities.sort_by { |w| w.created_at }
    @activities = @activities.paginate page: params[:activities_page]
    @activities.each { |a| a.row_class = get_row_class(a) }
  end


  def destroy
    @worker = Worker.find(params[:id])
    @worker.destroy
    flash[:success] = t '.success'
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
