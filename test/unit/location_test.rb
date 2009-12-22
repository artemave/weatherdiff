require File.dirname(__FILE__)+'/../test_helper'

class LocationTest < ActiveSupport::TestCase
	fixtures :locations
  # Replace this with your real tests.

	test "new location" do
		p = Location.new :name => 'France, Paris', :feed => 'http://feeds.bbc.co.uk/weather/feeds/rss/5day/world/40.xml', :tz => 'Paris'
		assert p.save, p.errors.full_messages
	end

	test "is location sampled?" do
		p = Location.new :name => 'France, Paris', :feed => 'http://feeds.bbc.co.uk/weather/feeds/rss/5day/world/40.xml', :tz => 'Paris'
		assert !p.already_sampled?(Time.now.in_time_zone('Paris')), 'No samples for today'
	end

	test "sample" do
		p = Location.new :name => 'France, Paris', :feed => 'http://feeds.bbc.co.uk/weather/feeds/rss/5day/world/40.xml', :tz => 'Paris'
		p.save
		p.sample
		assert p.samples.count == 3, "#{p.samples.count} samples taken"
		assert p.already_sampled?(Time.now.in_time_zone('Paris')), 'Today is already sampled'
	end
end
