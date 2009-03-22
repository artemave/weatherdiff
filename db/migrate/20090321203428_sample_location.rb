class SampleLocation < ActiveRecord::Migration
  def self.up
		add_column :samples, :location_id, :integer, :null => false

		execute 'alter table samples add constraint fk_sample_location
			foreign key (location_id) references locations (id)'
  end

  def self.down
		execute 'alter table samples drop foreign key fk_sample_location'

		remove_column :samples, :location_id
  end
end
