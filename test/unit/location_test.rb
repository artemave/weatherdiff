require File.dirname(__FILE__)+'/../test_helper'

class LocationTest < ActiveSupport::TestCase
	fixtures :locations
  # Replace this with your real tests.

	test "new location" do
		p = Location.new :name => 'France, Paris', :feed => 'http://newsrss.bbc.co.uk/weather/forecast/40/Next3DaysRSS.xml', :tz => 'Paris'
		assert p.save, p.errors.full_messages
	end

	test "is location sampled?" do
		p = Location.new :name => 'France, Paris', :feed => 'http://newsrss.bbc.co.uk/weather/forecast/40/Next3DaysRSS.xml', :tz => 'Paris'
		assert !p.already_sampled?(Time.now.to_date), 'No samples for today'
	end

	test "sample" do
		p = Location.new :name => 'France, Paris', :feed => 'http://newsrss.bbc.co.uk/weather/forecast/40/Next3DaysRSS.xml', :tz => 'Paris'
		p.save
		p.sample
		assert p.samples.count == 3, "#{p.samples.count} samples taken"
		assert p.already_sampled?(Time.now.to_date), 'Today is already sampled'
	end
end
