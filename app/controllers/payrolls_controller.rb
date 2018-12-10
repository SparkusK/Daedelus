class PayrollsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_payroll, only: [:show, :edit, :update, :destroy]

  # GET /payrolls
  # GET /payrolls.json
  def index
    params[:start_date] = 2.months.ago if params[:start_date].nil?
    params[:end_date] = 1.months.ago if params[:end_date].nil?
    date1 = params[:start_date]
    date2 = params[:end_date]

    if date1 < date2
      start_date = date1
      end_date = date2
    else
      start_date = date2
      end_date = date1
    end

    records = LaborRecord.where("labor_date > ? AND labor_date < ?", start_date, end_date)

    @employee_details = Hash.new{ |hash, key| hash[key] = {normal_time: 0.0, sunday_time: 0.0}}
    records.each { |record|
      if record.labor_date.wday == 0 #sundays
        @employee_details[record.employee_id][:sunday_time] = @employee_details[record.employee_id][:sunday_time] + record.hours
      else
        @employee_details[record.employee_id][:normal_time] = @employee_details[record.employee_id][:normal_time] + record.hours
      end
    }
    @employee_details
  end

  # GET /payrolls/new
  def new
    @payroll = Payroll.new
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_payroll
    #   @payroll = Payroll.find(params[:id])
    # end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payroll_params
      params.fetch(:start_date) {2.months.ago}
      params.fetch(:end_date) {1.months.ago}
    end
end
