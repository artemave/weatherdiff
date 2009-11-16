class Sample < ActiveRecord::Base
	belongs_to :sample_summary
	validates_presence_of :name, :value
	validates_associated :sample_summary
end
