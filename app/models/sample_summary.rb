class SampleSummary < ActiveRecord::Base
  has_many :samples
  belongs_to :location
	validates_presence_of :rss_ts
	validates_associated :location
  validates_uniqueness_of :location_id, :scope => :rss_ts

  default_scope :include => :samples
end
