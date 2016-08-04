class Call < ActiveRecord::Base
  belongs_to :worker

  DAYS_TO_KEEP = 30

  private
    # When a call is created, delete all calls
    # which are older than they should be
    # TODO: Move to a cronjob
    def check_worker_calls_count
      unless worker.nil? || worker.calls.count == 0
        # A while instead of an if just in case
        while worker.calls.first.created_at <= DAYS_TO_KEEP.days.ago
          worker.calls.first.destroy
        end
      end
    end
end
