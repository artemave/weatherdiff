require 'array-utils'
require 'location'

class Report
  attr_accessor :locations
  attr_reader :flot
  attr_reader :id #XXX secret kick for form_for(@report...) to work

  def initialize(params = {})
    @locations = params[:locations] ? fetch_locations(params[:locations]) : []
    @flot = {}
  end

  def generate_flot_data!
    max_y, min_y, min_ts, max_ts = {}, {}, nil
    @flot[:data] = Hash.new { |h,k| h[k] = Hash.new { |h,k| h[k] = [] } }

    @locations.each do |loc|
      for ss in loc.sample_summaries
        ts = Time.gm(ss.rss_ts.year, ss.rss_ts.month, ss.rss_ts.day).to_i * 1000 # flot likes miliseconds
        max_ts = ts unless max_ts and max_ts > ts
        min_ts = ts unless min_ts and min_ts < ts
        
        @flot[:data][loc.name][:max_temp] << [ts, ss.max_temp]
        max_y[:t] = ss.max_temp.to_i unless max_y[:t] and max_y[:t] > ss.max_temp.to_i

        @flot[:data][loc.name][:min_temp] << [ts, ss.min_temp]
        min_y[:t] = ss.min_temp.to_i unless min_y[:t] and min_y[:t] < ss.min_temp.to_i
        
        @flot[:data][loc.name][:overview] << [ts, ss.overview.flotify]
      end
    end
    
    min_y[:t] -= 5
    max_y[:t] += 5
    min_y[:overview] = SampleSummary::TO_FLOT.values.min - 1
    max_y[:overview] = SampleSummary::TO_FLOT.values.max + 1

    @flot[:sensors] = [
      {:key => :overview, :name => 'Overview', :min_y => min_y[:overview], :max_y => max_y[:overview] },
      {:key => :max_temp, :name => 'Maximum temperature', :min_y => min_y[:t], :max_y => max_y[:t] },
      {:key => :min_temp, :name => 'Minimum temperature', :min_y => min_y[:t], :max_y => max_y[:t] },
    ]

    @flot[:zoom_range] = [1000 * 60 * 60 * 24 * 7, max_ts - min_ts]; # week to max period
    @flot[:pan_range] = [min_ts, max_ts];
  end

  # a secret kick for restful routes to work
  def new_record?
    true
  end

  private

  def fetch_locations(loc_names)
    missing_locations = []
    ambiguous_locations = []
    locations = []

    loc_names.each do |ln|
      loc = Location.find(
        :all,
        :conditions => ["name like ?", "%#{ln}%"],
        :include => [:sample_summaries, :samples]
      )

      if loc.empty?
        missing_locations << ln
      elsif loc.size > 1
        ambiguous_locations << loc
      else
        locations << loc.first
      end
    end

    if missing_locations.size > 0
      raise Location::NotFound.new missing_locations
    end

    if ambiguous_locations.size > 0
      raise Location::Ambiguous.new ambiguous_locations
    end

    locations
  end
end
