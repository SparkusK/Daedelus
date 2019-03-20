class JobsController < AdministrativeController
  before_action :authenticate_user!
  before_action :set_job, only: [:show, :edit, :update, :destroy]
  before_action :set_dates, only: :index
  # GET /jobs
  # GET /jobs.json
  def index
    @jobs = Job.search(
      params[:keywords],
      @target_start_date, @target_end_date,
      @receive_start_date, @receive_end_date,
      params[:page], params[:targets], params[:completes]
    )
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
    respond_to do |format|
      if @job.save
        format.html { redirect_to jobs_path, notice: "#{@job} was successfully created." }
        format.json { render :show, status: :created, location: entity }
      else
        format.html { render :new }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
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
          format.js { render 'edit' }
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
      target_start_date_valid = !params[:target_start_date].nil? && !params[:target_start_date].empty?
      target_end_date_valid = !params[:target_end_date].nil? && !params[:target_end_date].empty?
      receive_start_date_valid = !params[:receive_start_date].nil? && !params[:receive_start_date].empty?
      receive_end_date_valid = !params[:receive_end_date].nil? && !params[:receive_end_date].empty?

      # Initialize the dates
      if target_start_date_valid
        @target_start_date = params[:target_start_date]
      else
        @target_start_date = nil
      end
      if target_end_date_valid
        @target_end_date = params[:target_end_date]
      else
        @target_end_date = nil
      end
      if receive_start_date_valid
        @receive_start_date = params[:receive_start_date]
      else
        @receive_start_date = nil
      end
      if receive_end_date_valid
        @receive_end_date = params[:receive_end_date]
      else
        @receive_end_date = nil
      end

      # Swap the two dates if start_date is_after end_date
      unless !target_start_date_valid || !target_end_date_valid
        date1 = params[:target_start_date]
        date2 = params[:target_end_date]
        if date1 < date2
          @target_start_date = date1
          @target_end_date   = date2
        else
          @target_start_date = date2
          @target_end_date   = date1
        end
      end
      unless !receive_start_date_valid || !receive_end_date_valid
        date1 = params[:receive_start_date]
        date2 = params[:receive_end_date]
        if date1 < date2
          @receive_start_date = date1
          @receive_end_date   = date2
        else
          @receive_start_date = date2
          @receive_end_date   = date1
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_params
      params.require(:job).permit(
        :receive_date,
        :section_id,
        :contact_person,
        :responsible_person,
        :total,
        :work_description,
        :jce_number,
        :quotation_reference,
        :receive_start_date,
        :receive_end_date,
        :page,
        :targets,
        :completes,
        :is_finished,
        :job_number,
        :order_number,
        :client_section
      )
    end
end
