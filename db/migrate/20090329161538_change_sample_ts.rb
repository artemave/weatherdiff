class ChangeSampleTs < ActiveRecord::Migration
  def self.up
		rename_column :samples, :date_taken, :rss_ts
		change_column :samples, :rss_ts, :datetime
  end

  def self.down
		change_column :samples, :rss_ts, :date
		rename_column :samples, :rss_ts, :date_taken
  end
end
