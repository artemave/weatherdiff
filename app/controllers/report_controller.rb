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
    rescue LocationNotFound => e
      render :template => 'shared/error_box', :locals => {:error_text => e.missing_locations.join(',')}
    end
  end
end
