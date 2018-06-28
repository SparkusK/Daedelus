class SupervisorsController < ApplicationController
  before_action :set_supervisor, only: [:show, :edit, :update, :destroy]

  # GET /supervisors
  # GET /supervisors.json
  def index
    @supervisors = params[:keywords].present? ?
      Supervisor.search(params[:keywords]).paginate(page: params[:page]) :
      Supervisor.paginate(page: params[:page])
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # GET /supervisors/1
  # GET /supervisors/1.json
  def show
  end

  # GET /supervisors/new
  def new
    @supervisor = Supervisor.new
  end

  # GET /supervisors/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /supervisors
  # POST /supervisors.json
  def create
    @input_params = {:employee_id=> params[:employee][:employee_id],
                     :section_id => params[:section][:section_id]}
    @supervisor = Supervisor.new(@input_params)

    respond_to do |format|
      if @supervisor.save
        format.html { redirect_to @supervisor, notice: 'Supervisor was successfully created.' }
        format.json { render :show, status: :created, location: @supervisor }
      else
        format.html { render :new }
        format.json { render json: @supervisor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /supervisors/1
  # PATCH/PUT /supervisors/1.json
  def update
    respond_to do |format|
      if params[:commit] == "Save"
        if @supervisor.update(supervisor_params)
          format.html { redirect_to @supervisor, notice: 'Supervisor was successfully updated.' }
          format.json { render :show, status: :ok, location: @supervisor }
          format.js
        else
          format.html { render :edit }
          format.json { render json: @supervisor.errors, status: :unprocessable_entity }
        end
      else
        format.js { render action: "cancel" }
      end
    end
  end

  def cancel
    id = params[:id]
    @supervisor = Supervisor.find_by(id: id)
    respond_to do |format|
      format.js
    end
  end

  # DELETE /supervisors/1
  # DELETE /supervisors/1.json
  def destroy
    @supervisor.destroy
    respond_to do |format|
      format.html { redirect_to supervisors_url, notice: 'Supervisor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supervisor
      @supervisor = Supervisor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supervisor_params
      params.require([:employee, :section])
    end
end
