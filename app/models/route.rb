class Route < ActiveRecord::Base
  belongs_to :site

  validates :name, presence: true, length: { maximum: 40 }
end
