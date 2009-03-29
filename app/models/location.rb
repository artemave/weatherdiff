require 'rss/2.0'
require 'open-uri'

class Location < ActiveRecord::Base
	has_many :samples
	validates_presence_of :name, :feed, :tz
	validates_uniqueness_of :name, :feed

	def sample
		Time.zone = tz
		today = Date.today

		return if already_sampled?(today)

		content = ''
		open(feed) {|s| content = s.read }
		rss = RSS::Parser.parse(content, false)

		raise "Empty feed for #{name} on #{today}" if rss.items.empty?

		rss_ts = rss.channel.date.in_time_zone(tz)

		if rss_ts.to_date != today
			raise "#{today} is not sampled, however feed ts is not for today #{rss_ts}"
		end

		rss.items[0].title.split(',').each_with_index do |ri, i|
			ri =~ /^\s*([^:]+)\s*:\s*(.*)\s*$/
			name, val = $1, $2

			# Title is a string like this:
			# 'Sunday: sunny, Max Temp: 11&#xB0;C (52&#xB0;F), Min Temp: 2&#xB0;C (36&#xB0;F)'
			# below we want to check if weekday equals to current. Because it can be for the 
			# day after
			if i == 0 
				if name != rss_ts.strftime('%A')
					logger.debug "First item in todays - #{rss_ts} - feed covers the day after. Skipping. #{rss.items[0].title}"
					return
				else
					name = 'brief' # we don't want weekday in db
				end
			end

			val.gsub!(/.*?(\d+).*/, '\1') # leave only celcius temperature value

			Sample.new(:name => name, :value => val, :rss_ts => rss_ts.to_datetime, :location => self).save
		end
	end

	def already_sampled?(date)
		samples.find :first, :conditions => [ 'DATE(rss_ts) = ?', date ]
	end
end
