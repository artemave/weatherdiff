class AddTzToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :tz, :string
  end

  def self.down
    remove_column :locations, :tz
  end
end
