class SampleSummary < ActiveRecord::Base
  has_many :samples
  belongs_to :location
	validates_presence_of :rss_ts
	validates_associated :location
  validates_uniqueness_of :location_id, :scope => :rss_ts

  default_scope :include => :samples, :order => 'rss_ts desc'

  cattr_reader :per_page
  @@per_page = 20

  def briefly
    s = samples.detect {|s| s.name == 'briefly' }
    s and s.value
  end

  def max_temp
    s = samples.detect {|s| s.name == 'Max Temp' }
    s and s.value
  end

  def min_temp
    s = samples.detect {|s| s.name == 'Min Temp' }
    s and s.value
  end
end
