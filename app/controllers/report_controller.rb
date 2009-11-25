class ReportController < ApplicationController
  layout 'pretty'

  def new
    @report = Report.new
  end

  def create
  end
end
