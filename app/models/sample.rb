class Sample < ActiveRecord::Base
	belongs_to :location
	validates_presence_of :name, :value, :date_taken
	validates_associated :location
end
