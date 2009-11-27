class Report
  attr_accessor :location1, :location2

  def generate!
    ls = Location.with_samples.find(:all, :conditions => ['name in (?,?)', location1, location2]);
  end

  # a secret kick for restful routes to work
  def new_record?
    true
  end
end
