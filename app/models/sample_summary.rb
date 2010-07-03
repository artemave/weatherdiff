class SampleSummary < ActiveRecord::Base
  has_many :samples, :dependent => :destroy
  belongs_to :location
	validates_presence_of :rss_ts
	validates_associated :location
  validates_uniqueness_of :location_id, :scope => :rss_ts

  default_scope :include => :samples, :order => 'rss_ts desc'

  def after_create
    logger.info "Sample summary: " + self.inspect
  end

  cattr_reader :per_page
  @@per_page = 20

  TO_FLOT = {
    'light rain'          => 2,
    'heavy showers'       => 1,
    'sunny'               => 6,
    'heavy rain'          => 1.001,
    'drizzle'             => 3,
    'sunny intervals'     => 5,
    'cloudy'              => 4,
    'white cloud'         => 4.002,
    'grey cloud'          => 3.003,
    'light showers'       => 2.001,
    'light snow'          => 2.002,
    'light snow showers'  => 2.003,
    'light snow shower'   => 4.001,
    'thundery showers'    => 1.002,
    'thundery shower'     => 1.008,
    'misty'               => 3.001,
    'mist'                => 3.005,
    'heavy snow'          => 1.003,
    'heavy snow shower'   => 1.005,
    'heavy snow showers'  => 1.006,
    'sleet'               => 2.004,
    'sleet shower'        => 2.005,
    'sleet showers'       => 2.006,
    'light rain shower'   => 2.007,
    'heavy rain shower'   => 1.004,
    'hail shower'         => 1.007,
    'foggy'               => 3.002,
    'fog'                 => 3.004,
  }

  def overview
    s = samples.detect {|s| s.name == 'overview' } or return

    val = s.value
    val.instance_eval do
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
