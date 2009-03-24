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
		assert !p.already_sampled?(Time.now), 'No samples for today'
	end

	test "sample" do
		p = Location.new :name => 'France, Paris', :feed => 'http://feeds.bbc.co.uk/weather/feeds/rss/5day/world/40.xml'
		p.save
		p.sample Time.now
		assert p.samples.length == 3, "#{samples.length} samples taken"
	end
end
