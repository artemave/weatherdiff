class ChangeBrieflyToOverview < ActiveRecord::Migration
  def self.up
    execute "update samples set name='overview' where name='briefly'"
  end

  def self.down
    execute "update samples set name='briefly' where name='overview'"
  end
end
