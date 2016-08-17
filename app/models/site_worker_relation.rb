# Represents a site-worker has_and_belongs_to_many relation
class SiteWorkerRelation < ActiveRecord::Base
  belongs_to :site
  belongs_to :worker
end
