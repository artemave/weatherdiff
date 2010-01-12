require 'rss/2.0'
require 'open-uri'

class Location < ActiveRecord::Base
	has_many :sample_summaries, :dependent => :destroy
  has_many :samples, :through => :sample_summaries # that is for named_scope to get all the data in few queries
	validates_presence_of :name, :feed, :tz
	validates_uniqueness_of :name, :feed

  named_scope :with_samples, :include => [:sample_summaries, :samples]

	def sample
		today = Time.now.to_date

		return if already_sampled?(today)

		logger.info "Start sampling #{name} for #{today}"

		content = ''
		open(feed) {|s| content = s.read }
		rss = RSS::Parser.parse(content, false)

		raise "Empty feed for #{name} on #{today}" if rss.items.empty?

    first_item = rss.items[0]

    unless first_item.guid.to_s =~ /#{today}/
      logger.info "First feed item #{first_item.guid} #{first_item.guid} does not cover today #{today}. Skipping."
      return
    end

    ss = nil
		first_item.title.split(',').each_with_index do |ri, i|
			ri =~ /^\s*([^:]+)\s*:\s*(.*)\s*$/
			sample_name, val = $1, $2

			# Title is a string like this:
			# 'Sunday: sunny, Max Temp: 11&#xB0;C (52&#xB0;F), Min Temp: 2&#xB0;C (36&#xB0;F)'
			# below we want to check if weekday equals to current. Because it can be for the 
			# day after
			if i == 0 
				sample_name = 'overview' # we don't want weekday in db
        ss = SampleSummary.create!(:rss_ts => Time.now.to_datetime, :location => self)
			  logger.info "Sample summary: #{ss.inspect}"
			end

			val.gsub!(/.*?(-?\d+).*/, '\1') # leave only celcius temperature value

			s = Sample.create!(:name => sample_name, :value => val, :sample_summary => ss)
			logger.info "Sample: #{s.inspect}"
		end
	end

	def already_sampled?(date)
		logger.info "Is #{name} already sampled for #{date}?"
		if sample_summaries.find :first, :conditions => [ 'DATE(rss_ts) = ?', date ]
      logger.info "Yes"
      return true
    else
      logger.info "No"
      return false
    end
	end
end
