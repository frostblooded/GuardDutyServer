class Call < ActiveRecord::Base
  belongs_to :worker

  before_create :generate_token

  def valid_token?(passed_token)
    self.token == passed_token
  end

  def answered?
    !unanswered?
  end

  def unanswered?
    self.received_at.nil?
  end

  private
    def generate_token
      # Generate again if token already exists
      begin
        self.token = SecureRandom.hex
      end while self.class.exists?(token: token)
    end
end
