class Report
  attr_accessor :location1, :location2
  attr_reader :flot

  def initialize(params = {})
    @location1 = params[:location1]
    @location2 = params[:location2]
    @flot = {}
  end

  def generate_flot_data
    ls = Location.with_samples.find(:all, :conditions => ['name in (?,?)', location1, location2]);
    max_y, min_y, min_ts, max_ts = nil, nil, nil, nil
    @flot[:data] = Hash.new { |h,k| h[k] = Hash.new { |h,k| h[k] = [] } }
    ls.each do |loc|
      for ss in loc.sample_summaries
        ts = Time.gm(ss.rss_ts.year, ss.rss_ts.month, ss.rss_ts.day).to_i * 1000 # flot likes miliseconds
        max_ts = ts unless max_ts and max_ts > ts
        min_ts = ts unless min_ts and min_ts < ts
        
        @flot[:data][loc.name][:max_temp] << [ts, ss.max_temp]
        max_y = ss.max_temp.to_i unless max_y and max_y > ss.max_temp.to_i

        @flot[:data][loc.name][:min_temp] << [ts, ss.min_temp]
        min_y = ss.min_temp.to_i unless min_y and min_y < ss.min_temp.to_i
        
        @flot[:data][loc.name][:briefly] << [ts, ss.briefly]
      end
    end
    min_y -= 5
    max_y += 5
    @flot[:sensors] = [
      {:key => :max_temp, :name => 'Maximum temperature', :min_y => min_y, :max_y => max_y },
      {:key => :min_temp, :name => 'Minimum temperature', :min_y => min_y, :max_y => max_y },
    ]

    @flot[:zoom_range] = [1000 * 60 * 60 * 24 * 7, max_ts - min_ts]; # week to max period
    @flot[:pan_range] = [min_ts, max_ts];
  end

  # a secret kick for restful routes to work
  def new_record?
    true
  end
end
