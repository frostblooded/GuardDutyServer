class ApiKey < ActiveRecord::Base
  belongs_to :company
  
  before_create :generate_access_token

  VALID_HOURS = 2

  def expired?
    created_at < VALID_HOURS.hours.ago
  end

  private
    def generate_access_token
      # Generate again if token already exists
      begin
        self.access_token = SecureRandom.hex
      end while self.class.exists?(access_token: access_token)
    end
end
