#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "development"

require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do 
  $running = false
end

while $running do
	RAILS_DEFAULT_LOGGER.info "It is #{Time.now}. Time to check for new samples."
	Location.find(:all).each do |loc|
		loc.sample unless loc.already_sampled?(Date.today)
		break unless $running
	end
  
  360.times do
		break unless $running
		sleep 5
	end
end

