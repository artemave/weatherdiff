require 'location'

class ReportController < ApplicationController
  layout 'pretty'

  def new
    @report = Report.new
    @locations = Location.all
  end

  def create
    begin
      @report = Report.new(params[:report])
      @report.generate_flot_data!
    rescue Location::NotFound => e
      render :template => 'shared/error_box', :locals => {:error_text => "No data for " + e.missing_locations.join('; ')}
    rescue Location::Ambiguous => e
      render :template => 'shared/error_box', :locals => {:error_text => "Did you mean " + e.ambiguous_locations.map{|ls| ls.map{|l| %{"#{l.name}"}}.join(' or ')}.join('? ') + '?'}
    end
  end
end
