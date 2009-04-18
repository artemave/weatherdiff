require 'rss/2.0'
require 'open-uri'
require 'facets/hash'

class Location < ActiveRecord::Base
	has_many :samples
	validates_presence_of :name, :feed, :tz
	validates_uniqueness_of :name, :feed

	def sample
		Time.zone = tz
		today = Date.today

		return if already_sampled?(today)

		logger.debug "Start sampling #{name} for #{today}"

		content = ''
		open(feed) {|s| content = s.read }
		rss = RSS::Parser.parse(content, false)

		raise "Empty feed for #{name} on #{today}" if rss.items.empty?

		rss_ts = rss.channel.date.in_time_zone(tz)

		if rss_ts.to_date != today
			logger.debug "#{today} is not sampled, however feed ts is not for today #{rss_ts}. Skipping."
			return
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
					name = 'briefly' # we don't want weekday in db
				end
			end

			val.gsub!(/.*?(\d+).*/, '\1') # leave only celcius temperature value

			s = Sample.new(:name => name, :value => val, :rss_ts => rss_ts.to_datetime, :location => self).save

			logger.debug "Sample taken: #{s.inspect}"
		end
	end

	def already_sampled?(date)
		samples.find :first, :conditions => [ 'DATE(rss_ts) = ?', date ]
	end

	def formatted_samples
		fmt_samples = Hash.autonew
		samples.to_a.each do |s|
			fmt_samples[s.rss_ts.to_s][s.name] = s.value
			fmt_samples[s.rss_ts.to_s][:date] = s.rss_ts.to_s
		end

		result = []
		fmt_samples.keys.sort.each do |k|
			result << fmt_samples[k]
		end
		result
	end
end
