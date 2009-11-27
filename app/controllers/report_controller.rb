class ReportController < ApplicationController
  layout 'pretty'

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(params[:report])
    @report.generate! #TODO error handling
    
    respond_to do |format|
      format.js
    end
  end
end
