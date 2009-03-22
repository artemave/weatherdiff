class Sample < ActiveRecord::Base
	belongs_to :location
	validates_presense_of :name, :value, :date_taken
	validates_assotiated :location
end
