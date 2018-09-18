class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  # GET /employees
  # GET /employees.json
  def index
    @employees = params[:keywords].present? ?
      Employee.search(params[:keywords]).includes(:section).paginate(page: params[:page]) :
      Employee.includes(:section).paginate(page: params[:page])
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end


  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.json { render :show, status: :created, location: @employee }
        format.js
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if params[:commit] == "Save"
        if @employee.update(employee_params)
          format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
          format.json { render :show, status: :ok, location: @employee }
          format.js
        else
          format.html { render :edit }
          format.json { render json: @employee.errors, status: :unprocessable_entity }
          format.js
        end
      else
        format.js { render action: "cancel" }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url, notice: 'Employee records have successfully been destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /employees/2.js
  def cancel
    id = params[:id]
    @employee = Employee.find_by(id: id)
    respond_to do |format|
      format.js
    end
  end

  # AJAX GET /employees/7/rates.json
  def ajax_rates
    emp = Employee.find_by(id: params[:id])
    @rates = { inclusive_rate: emp.inclusive_rate, exclusive_rate: emp.net_rate }

    respond_to do |format|
      format.json {
        render json: @rates
      }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :occupation, :section_id, :company_number, :net_rate, :inclusive_rate, :eoc)
    end
end
