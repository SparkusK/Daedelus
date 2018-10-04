class JobsController < AdministrativeController
  before_action :set_job, only: [:show, :edit, :update, :destroy]

  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.search(params[:keywords], @start_date, @end_date, params[:page])
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
  end

  # GET /jobs/new
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @job = Job.new(job_params)
    create_boilerplate(@job)
  end

  # PATCH/PUT /jobs/1
  # PATCH/PUT /jobs/1.json
  def update
    respond_to do |format|
      if params[:commit] == "Save"
        if @job.update(job_params)
          format.html { redirect_to @job, notice: 'Job was successfully updated.' }
          format.json { render :show, status: :ok, location: @job }
          format.js
        else
          format.html { render :edit }
          format.json { render json: @job.errors, status: :unprocessable_entity }
        end
      else
        format.js { render action: "cancel"}
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job.destroy
    respond_to do |format|
      format.html { redirect_to jobs_url, notice: 'Job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = Job.find(params[:id])
    end

    def set_dates
      if params[:start_date].nil? || params[:end_date].nil?
        @start_date = nil
        @end_date = nil
      else
        date1 = params[:start_date]
        date2 = params[:end_date]
        if date1 < date2
          @start_date = date1
          @end_date = date2
        else
          @start_date = date2
          @end_date = date1
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(:receive_date, :section_id, :contact_person, :responsible_person, :total, :work_description, :jce_number, :targeted_amount, :quotation_reference, :target_date)
    end
end
