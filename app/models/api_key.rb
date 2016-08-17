# Represents an API key for API authorization
class ApiKey < ActiveRecord::Base
  belongs_to :company

  before_create :generate_access_token

  private

  def generate_access_token
    # Generate again if token already exists
    loop do
      self.access_token = SecureRandom.hex
      break unless self.class.exists?(access_token: access_token)
    end
  end
end
