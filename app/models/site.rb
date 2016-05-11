class Site < ActiveRecord::Base
  has_many :workers
  belongs_to :company
end
