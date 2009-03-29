class Sample < ActiveRecord::Base
	belongs_to :location
	validates_presence_of :name, :value, :rss_ts
	validates_associated :location
end
