class AddOldFeedToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :old_feed, :string
    Location.all.each do |l|
      l.old_feed = l.feed
      
      begin
        loc_id = /^.*?(\d+)\.xml$/.match(l.feed)[1]
      rescue
        next
      end

      loc_id = case loc_id.to_i # New bbc location codes. Damn their eyes.
               when 4825
                 2818 # Reading
               when 278
                 276 # Portland
               when 1125
                 644 # Conakry
               when 4564
                 2557 # Limerick
               when 4147
                 2167 # Chambery
               when 4182
                 2175 # Cherbourg
               when 5007
                 3000 # Toulouse
               else
                 loc_id
               end

      l.feed = "http://newsrss.bbc.co.uk/weather/forecast/#{loc_id}/Next3DaysRSS.xml"
      l.save!
    end
  end

  def self.down
    Location.all.each do |l|
      l.feed = l.old_feed
      l.save!
    end
    remove_column :locations, :old_feed
  end
end
