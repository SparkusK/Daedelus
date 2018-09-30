class SummariesController < ApplicationController

  # GET /summaries
  def index
    params[:start_date] = 1.months.ago if params[:start_date].nil?
    params[:end_date] = Date.today if params[:end_date].nil?
    date1 = params[:start_date]
    date2 = params[:end_date]

    if date1 < date2
      start_date = date1
      end_date = date2
    else
      start_date = date2
      end_date = date1
    end

    @summaries = Summary.build_summaries(start_date, end_date)
  end

  private
    def summary_params
      params.require(:summary).permit(:start_date, :end_date)
    end
end
