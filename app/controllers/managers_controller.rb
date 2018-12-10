class ManagersController < ApplicationController
  before_action :set_manager, only: [:show, :edit, :update, :destroy]

  # GET /managers
  # GET /managers.json
  def index
    @managers = params[:keywords].present? ?
      Manager.search(params[:keywords]).includes(:employee, :section).paginate(page: params[:page]) :
      Manager.includes(:employee, :section).paginate(page: params[:page])
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # GET /managers/1
  # GET /managers/1.json
  def show
  end

  # GET /managers/new
  def new
    @manager = Manager.new
  end

  # GET /managers/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /managers
  # POST /managers.json
  def create
    @input_params = {:employee_id=> params[:employee][:employee_id],
                     :section_id => params[:section][:section_id]}
    @manager = Manager.new(@input_params)
    respond_to do |format|
      if @manager.save
        format.html { redirect_to @manager, notice: 'Manager was successfully created.' }
        format.json { render :show, status: :created, location: @manager }
      else
        format.html { render :new }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
        format.js { render 'edit' }
      end
    end
  end

  # PATCH/PUT /managers/1
  # PATCH/PUT /managers/1.json
  def update
    respond_to do |format|
      if params[:commit] == "Save"
        if @manager.update(manager_params)
          format.html { redirect_to @manager, notice: 'Manager was successfully updated.' }
          format.json { render :show, status: :ok, location: @manager }
          format.js
        else
          format.html { render :edit }
          format.json { render json: @manager.errors, status: :unprocessable_entity }
        end
      else
        format.js { render action: "cancel" }
      end
    end
  end

  # DELETE /managers/1
  # DELETE /managers/1.json
  def destroy
    @manager.destroy
    respond_to do |format|
      format.html { redirect_to managers_url, notice: 'Manager was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def cancel
    id = params[:id]
    @manager = Manager.find_by(id: id)
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_manager
      @manager = Manager.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def manager_params
      params.require(:manager).permit(:employee_id, :section_id)
    end
end
