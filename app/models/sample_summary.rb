class SampleSummary < ActiveRecord::Base
  has_many :samples
  belongs_to :location
	validates_presence_of :rss_ts
	validates_associated :location
  validates_uniqueness_of :location_id, :scope => :rss_ts

  default_scope :include => :samples, :order => 'rss_ts desc'

  cattr_reader :per_page
  @@per_page = 20

  TO_FLOT = {
    'light rain'          => 2,
    'heavy showers'       => 1,
    'sunny'               => 6,
    'heavy rain'          => 1.01,
    'drizzle'             => 3,
    'sunny intervals'     => 5,
    'cloudy'              => 4,
    'light showers'       => 2.01,
    'light snow'          => 2.02,
    'light snow showers'  => 2.03,
    'thundery showers'    => 1.02,
    'misty'               => 3.01,
    'heavy snow'          => 1.03,
    'sleet'               => 2.04,
    'light rain shower'   => 2.05,
    'heavy rain shower'   => 1.04,
    'foggy'               => 3.02,
  }

  def briefly
    s = samples.detect {|s| s.name == 'briefly' }
    return unless s
    val = s.value
    class << val
      def flotify
        TO_FLOT["#{self}"]
      end
    end
    return val
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
