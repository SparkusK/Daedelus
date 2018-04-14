class LaborRecordsController < ApplicationController
  before_action :set_labor_record, only: [:show, :edit, :update, :destroy]

  # GET /labor_records
  # GET /labor_records.json
  def index
    @labor_records = LaborRecord.all
  end

  # GET /labor_records/1
  # GET /labor_records/1.json
  def show
  end

  # GET /labor_records/new
  def new
    @labor_record = LaborRecord.new
  end

  # GET /labor_records/1/edit
  def edit
  end

  # POST /labor_records
  # POST /labor_records.json
  def create
    @labor_record = LaborRecord.new(labor_record_params)

    respond_to do |format|
      if @labor_record.save
        format.html { redirect_to @labor_record, notice: 'Labor record was successfully created.' }
        format.json { render :show, status: :created, location: @labor_record }
      else
        format.html { render :new }
        format.json { render json: @labor_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /labor_records/1
  # PATCH/PUT /labor_records/1.json
  def update
    respond_to do |format|
      if @labor_record.update(labor_record_params)
        format.html { redirect_to @labor_record, notice: 'Labor record was successfully updated.' }
        format.json { render :show, status: :ok, location: @labor_record }
      else
        format.html { render :edit }
        format.json { render json: @labor_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /labor_records/1
  # DELETE /labor_records/1.json
  def destroy
    @labor_record.destroy
    respond_to do |format|
      format.html { redirect_to labor_records_url, notice: 'Labor record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_labor_record
      @labor_record = LaborRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def labor_record_params
      params.require(:labor_record).permit(:employee_id, :day_of_the_week, :labor_date, :hours, :total_before, :total_after, :supervisor_id, :job_id)
    end
end
