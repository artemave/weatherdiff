class CreateSamples < ActiveRecord::Migration
  def self.up
    create_table :samples do |t|
      t.date :date_taken
      t.string :name
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :samples
  end
end
