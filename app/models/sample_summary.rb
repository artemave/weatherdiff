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
    'heavy rain'          => 1.01,
    'drizzle'             => 3,
    'sunny intervals'     => 5,
    'cloudy'              => 4,
    'white cloud'         => 4.02,
    'grey cloud'          => 3.03,
    'light showers'       => 2.01,
    'light snow'          => 2.02,
    'light snow showers'  => 2.03,
    'light snow shower'   => 4.01,
    'thundery showers'    => 1.02,
    'thundery shower'     => 1.08,
    'misty'               => 3.01,
    'mist'                => 3.05,
    'heavy snow'          => 1.03,
    'heavy snow shower'   => 1.05,
    'heavy snow showers'  => 1.06,
    'sleet'               => 2.04,
    'sleet shower'        => 2.05,
    'sleet showers'       => 2.06,
    'light rain shower'   => 2.05,
    'heavy rain shower'   => 1.04,
    'hail shower'         => 1.07,
    'foggy'               => 3.02,
    'fog'                 => 3.04,
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
