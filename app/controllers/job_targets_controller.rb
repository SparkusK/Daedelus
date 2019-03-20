class JobTargetsController < ApplicationController
  before_action :set_job_target, only: [:show, :edit, :update, :destroy]

  # GET /job_targets
  # GET /job_targets.json
  def index
    @job_targets = params[:keywords].present? ?
      JobTarget.search(params[:keywords]).includes(:job, :section).paginate(page: params[:page]) :
      JobTarget.includes(:job, :section).paginate(page: params[:page])
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # GET /job_targets/1
  # GET /job_targets/1.json
  def show
  end

  # GET /job_targets/new
  def new
    @job_target = JobTarget.new
  end

  # GET /job_targets/1/edit
  def edit
  end

  # POST /job_targets
  # POST /job_targets.json
  def create
    @job_target = JobTarget.new(job_target_params)

    respond_to do |format|
      if @job_target.save
        format.html { redirect_to @job_target, notice: 'Job target was successfully created.' }
        format.json { render :show, status: :created, location: @job_target }
      else
        format.html { render :new }
        format.json { render json: @job_target.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_targets/1
  # PATCH/PUT /job_targets/1.json
  def update
    respond_to do |format|
      if @job_target.update(job_target_params)
        format.html { redirect_to @job_target, notice: 'Job target was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_target }
      else
        format.html { render :edit }
        format.json { render json: @job_target.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_targets/1
  # DELETE /job_targets/1.json
  def destroy
    @job_target.destroy
    respond_to do |format|
      format.html { redirect_to job_targets_url, notice: 'Job target was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_job_target
      @job_target = JobTarget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def job_target_params
      params.require(:job_target).permit(:target_date, :invoice_number, :remarks, :details, :target_amount, :section_id, :job_id)
    end
end
