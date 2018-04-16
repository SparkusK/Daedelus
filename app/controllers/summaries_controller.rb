class SummariesController < ApplicationController
  before_action :set_summary, only: [:show]
  # GET /summaries
  # GET /summaries.json

  def index

  end

  # GET /summaries/1
  # GET /summaries/1.json
  def show
  end

  # GET /summaries/new
  def new
  end

  # GET /summaries/1/edit
  def edit
  end

  # POST /summaries
  # POST /summaries.json
  def create
    respond_to do |format|
        format.html { render :show }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_summary
      @summary = Summary.new
      @summary.orders = ActiveRecord::Base.connection.execute(@summary.get_creditor_orders_for_this_month)
      @summary.labor = ActiveRecord::Base.connection.execute(@summary.get_labor_for_this_month)
      @summary.overheads = params[:overheads]
      @summary.target_jobs = params[:target_jobs]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def summary_params
      params.require(:summary).permit(:overheads, :target_jobs)
    end
end
