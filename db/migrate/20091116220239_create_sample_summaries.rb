class CreateSampleSummaries < ActiveRecord::Migration
  def self.up
    create_table :sample_summaries do |t|
      t.datetime :rss_ts
      t.integer :location_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sample_summaries
  end
end
