class AddOldFeedToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :old_feed, :string
    Location.all.each do |l|
      l.old_feed = l.feed.clone
      l.feed = l.feed.sub(/^.*?(\d+)\.xml$/, 'http://newsrss.bbc.co.uk/weather/forecast/\1/Next3DaysRSS.xml')
      l.save!
    end
  end

  def self.down
    Location.all.each do |l|
      l.feed = l.old_feed.clone
      l.save!
    end
    remove_column :locations, :old_feed
  end
end
