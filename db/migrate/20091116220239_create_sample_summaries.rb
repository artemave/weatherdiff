class CreateSampleSummaries < ActiveRecord::Migration
  def self.up
    create_table :sample_summaries do |t|
      t.datetime :rss_ts
      t.integer :location_id

      t.timestamps
    end

    add_column :samples, :sample_summary_id, :integer

    execute "insert into sample_summaries (rss_ts, location_id)
      select distinct rss_ts, location_id from samples
    "
    execute "update samples s, sample_summaries ss set s.sample_summary_id = ss.id
      where s.rss_ts = ss.rss_ts and s.location_id = ss.location_id
    "
    execute "alter table samples modify location_id int"
  end

  def self.down
    drop_table :sample_summaries

    remove_column :samples, :sample_summary_id
  end
end
