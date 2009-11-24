require 'rss/2.0'
require 'open-uri'

class Location < ActiveRecord::Base
	has_many :sample_summaries
	validates_presence_of :name, :feed, :tz
	validates_uniqueness_of :name, :feed

  named_scope :with_samples, :include => :sample_summaries

	def sample
		today = Time.now.in_time_zone(tz).to_date

		return if already_sampled?(today)

		logger.info "Start sampling #{name} for #{today}"

		content = ''
		open(feed) {|s| content = s.read }
		rss = RSS::Parser.parse(content, false)

		raise "Empty feed for #{name} on #{today}" if rss.items.empty?

		rss_ts = rss.channel.date.in_time_zone(tz)

		if rss_ts.to_date != today
			logger.info "#{today} is not sampled, however feed ts is not for today #{rss_ts}. Skipping."
			return
		end

    ss = nil
		rss.items[0].title.split(',').each_with_index do |ri, i|
			ri =~ /^\s*([^:]+)\s*:\s*(.*)\s*$/
			name, val = $1, $2

			# Title is a string like this:
			# 'Sunday: sunny, Max Temp: 11&#xB0;C (52&#xB0;F), Min Temp: 2&#xB0;C (36&#xB0;F)'
			# below we want to check if weekday equals to current. Because it can be for the 
			# day after
			if i == 0 
				if name != rss_ts.strftime('%A')
					logger.info "First item in todays - #{rss_ts} - feed covers the day after. Skipping. #{rss.items[0].title}"
					return
        end
				name = 'briefly' # we don't want weekday in db
        ss = SampleSummary.create(:rss_ts => rss_ts.to_datetime, :location => self)
			end

			val.gsub!(/.*?(-?\d+).*/, '\1') # leave only celcius temperature value

			s = Sample.create(:name => name, :value => val, :sample_summary => ss)

			logger.info "Sample taken: #{s.inspect}"
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
