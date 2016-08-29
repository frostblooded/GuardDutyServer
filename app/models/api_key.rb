# Represents an API key for API authorization
class ApiKey < ActiveRecord::Base
  belongs_to :company

  has_secure_token :access_token
end
