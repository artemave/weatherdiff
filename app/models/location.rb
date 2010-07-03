require 'rss/2.0'
require 'open-uri'

class Location < ActiveRecord::Base

  class NotFound < Exception
    attr_reader :missing_locations

    def initialize(loc_names, *args)
      @missing_locations = loc_names || []
      super(*args)
    end
  end

  class Ambiguous < Exception
    attr_reader :ambiguous_locations

    def initialize(loc_names, *args)
      @ambiguous_locations = loc_names || []
      super(*args)
    end
  end

	has_many :sample_summaries, :dependent => :destroy
  has_many :samples, :through => :sample_summaries # this is purely for :with_samples to get samples included
	validates_presence_of :name, :feed, :tz
	validates_uniqueness_of :name, :feed

  def before_save
    self.name = name.strip
  end

  named_scope :with_samples, :include => [:sample_summaries, :samples]

	def sample
		today = Time.zone.now.to_date

		return if already_sampled?(today)
    return if not first_sample_covers?(today)

		logger.info "Start sampling #{name} for #{today}"

    ss = sample_summaries.create(:rss_ts => Time.now.to_datetime)

    # extract overview
    # title is a string like this:
    # 'Sunday: sunny, Max Temp: 11&#xB0;C (52&#xB0;F), Min Temp: 2&#xB0;C (36&#xB0;F)'
    # we want only 'sunny' from here
    overview_value = first_feed_item.title.split(',').first.split(': ').last

    # save overview
    ss.samples.create(:name => 'overview', :value => overview_value)

    # extract and save individual values (temperature, wind, etc.)
    # description is a string like this:
    # Max Temp: 26&#xB0;C (79&#xB0;F), Min Temp: 20&#xB0;C (68&#xB0;F), Wind Direction: ENE, Wind Speed: 5mph, Visibility: very good, Pressure: 1013mb, Humidity: 46%, UV risk: low, Sunrise: 04:51MSD, Sunset: 22:15MSD
		first_feed_item.description.split(',').each do |ri|
			ri =~ /^\s*([^:]+)\s*:\s*(.*)\s*$/
			sample_name, val = $1, $2

      # leave only celcius temperatures
      if sample_name =~ /temp/i
        val.gsub!(/.*?(-?\d+).*/, '\1')
      end

			ss.samples.create(:name => sample_name, :value => val)
		end
	end

	def already_sampled?(date)
		logger.info "Is #{name} already sampled for #{date}?"
		if sample_summaries.find :first, :conditions => [ 'DATE(rss_ts) = ?', date ]
      logger.info "Yes"
      true
    else
      logger.info "No"
      false
    end
	end

  private

  def first_feed_item
		@first_feed_item ||= begin
      content = ''
      open(feed) {|s| content = s.read }
      rss = RSS::Parser.parse(content, false)

      raise "Empty feed for #{name} on #{today}" if rss.items.empty?

      rss.items[0]
    end
  end

  def first_sample_covers?(date)
    unless first_feed_item.guid.to_s =~ /#{date}/
      logger.info "First feed item #{first_feed_item.guid} #{first_feed_item.guid} does not cover date #{date}. Skipping."
      false
    else
      true
    end
  end
end
