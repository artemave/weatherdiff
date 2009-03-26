require File.dirname(__FILE__)+'/../test_helper'

class LocationTest < ActiveSupport::TestCase
	fixtures :locations
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

	test "new location" do
		p = Location.new :name => 'France, Paris', :feed => 'http://feeds.bbc.co.uk/weather/feeds/rss/5day/world/40.xml'
		assert p.save, p.errors.full_messages
	end

	test "is location sampled?" do
		p = Location.new :name => 'France, Paris', :feed => 'http://feeds.bbc.co.uk/weather/feeds/rss/5day/world/40.xml'
		assert !p.already_sampled?(Date.today), 'No samples for today'
	end

	test "sample" do
		p = Location.new :name => 'France, Paris', :feed => 'http://feeds.bbc.co.uk/weather/feeds/rss/5day/world/40.xml'
		p.save
		p.sample Date.today
		assert p.samples.count == 3, "#{p.samples.count} samples taken"
		assert p.already_sampled?(Date.today), 'Today is already sampled'
	end
end
