class MoreIndexes < ActiveRecord::Migration
  def self.up
    add_index :samples, :sample_summary_id
    add_index :sample_summaries, :location_id
  end

  def self.down
    remove_index :samples, :sample_summary_id
    remove_index :sample_summaries, :location_id
  end
end
