class ApiKey < ActiveRecord::Base
  before_create :generate_access_token

  private
    def generate_access_token
      # May need to repeat if token already exists
      begin
        self.access_token = SecureRandom.hex
      end while self.class.exists?(access_token: access_token)
    end
end
