class Report
  attr_accessor :location1, :location2

  # a secret kick for restful routes to work
  def new_record?
    true
  end
end
