class Call < ActiveRecord::Base
  belongs_to :worker

  before_create :generate_token, :check_worker_calls_count

  DAYS_TO_KEEP = 30

  def valid_token?(passed_token)
    self.token == passed_token
  end

  def answered?
    !self.received_at.nil?
  end

  private
    def generate_token
      # Generate again if token already exists
      begin
        self.token = SecureRandom.hex
      end while self.class.exists?(token: token)
    end

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
