module DataManipulation
  class EmployeesController < AdministrativeController
    before_action :set_employee, only: [:show, :edit, :update, :destroy]
    before_action :set_employees, only: :index
    before_action :new_employee, only: :new

    # AJAX GET /employees/7/rates.json
    def ajax_rates
      emp = Employee.find_by(id: params[:id])
      @rates = { inclusive_rate: emp.inclusive_rate, exclusive_rate: emp.net_rate }
      respond_to { |format| format.json { render json: @rates } }
    end

    # AJAX GET /employees/7/labor_dates.json
    def ajax_labor_dates
      @dates_hash = Employee.get_labor_record_dates(params[:id])
      respond_to do |format|
        format.json { render json: @dates_hash }
        format.html { render json: @dates_hash }
      end
    end

    private
      def set_employee
        @employee = Employee.find(params[:id])
      end

      def set_employees
        @employees = params[:keywords].present? ?
          Employee.search(params[:keywords]).includes(:section).paginate(page: params[:page]) :
          Employee.includes(:section).paginate(page: params[:page])
      end

      def new_employee
        @employee = Employee.new
      end

      def instance
        @employee
      end

      def whitelist_params
        params.require(:employee).permit(:first_name, :last_name, :occupation,
          :section_id, :company_number, :net_rate, :inclusive_rate, :eoc)
      end
  end
end
