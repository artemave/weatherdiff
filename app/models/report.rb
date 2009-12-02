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
    @flot[:data] = Hash.new { |h,k| h[k] = Hash.new { |h,k| h[k] = [] } }
    ls.each do |loc|
      for ss in loc.sample_summaries
        ts = Time.gm(ss.rss_ts.year, ss.rss_ts.month, ss.rss_ts.day).to_i * 1000 # flot likes miliseconds
        @flot[:data][loc.name][:max_temp] << [ts, ss.max_temp]
        @flot[:data][loc.name][:min_temp] << [ts, ss.min_temp]
        @flot[:data][loc.name][:briefly] << [ts, ss.briefly]
      end
    end
    @flot[:sensors] = [:max_temp, :min_temp]
  end

  # a secret kick for restful routes to work
  def new_record?
    true
  end
end
