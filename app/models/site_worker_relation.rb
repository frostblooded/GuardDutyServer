class SiteWorkerRelation < ActiveRecord::Base
  belongs_to :site
  belongs_to :worker
end
