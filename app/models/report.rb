require 'facets/hash'

class Report
  attr_accessor :location1, :location2
  attr_reader :flot

  def initialize(params = {})
    @location1 = params[:location1]
    @location2 = params[:location2]
    @flot = Hash.autonew
  end

  def generate_flot
    ls = Location.with_samples.find(:all, :conditions => ['name in (?,?)', location1, location2]);
    color = 1
    @flot[:series] = []
    ls.each do |loc|
      for ss in loc.sample_summaries
        ts = Time.gm(ss.rss_ts.year, ss.rss_ts.month, ss.rss_ts.day).to_i * 1000
        (max_temp_data ||= []) << [ts, ss.max_temp]
        (min_temp_data ||= []) << [ts, ss.min_temp]
      end

      @flot[:series] << {
        :color => color,
        :label => loc.name,
        :data => max_temp_data
      } << {
        :color => color,
        :shadowSize => 5,
        :data => min_temp_data
      }

      color+= 1
    end

    @flot[:options][:xaxis][:mode] = 'time'
  end

  # a secret kick for restful routes to work
  def new_record?
    true
  end
end
