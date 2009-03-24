require 'rss/2.0'
require 'open-uri'

class Location < ActiveRecord::Base
	has_many :samples
	validates_presence_of :name, :feed
	validates_uniqueness_of :name, :feed

	def sample(date)
		return if already_sampled?(date)

		content = ''
		open(feed) {|s| content = s.read }
		rss = RSS::Parser.parse(content, false)

		raise "Empty feed for #{name} on #{date.to_s}" if rss.items.empty?

		if rss.channel.date.strftime('%Y-%m-%d') != date.strftime('%Y-%m-%d')
			logger.info "Feed for #{name} on #{date.to_s} is not there: actual feed date is #{rss.channel.date.to_s}"
			return
		end

		# take only first (today's) item
		#
		rss.items[0].title.split(',').each do |ri|
			ri =~ /\s*([^:]+)\s*:\s*(.*)\s*/
			Sample.new(:name => $1, :value => $2, :date_taken => date, :location => self).save
		end
	end

	def already_sampled?(date)
		samples.detect {|s| s.date_taken == date.strftime('%Y-%m-%d') }
	end
end
