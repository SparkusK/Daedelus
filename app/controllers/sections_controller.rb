class SectionsController < ApplicationController
  before_action :set_section, only: [:show, :edit, :update, :destroy]

  # GET /sections
  # GET /sections.json
  def index
    @sections = params[:keywords].present? ?
      Section.search(params[:keywords]).includes(manager: :employee).paginate(page: params[:page]) :
      Section.includes(manager: :employee).paginate(page: params[:page])
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
  end

  # GET /sections/new
  def new
    @section = Section.new
  end

  # GET /sections/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /sections
  # POST /sections.json
  def create
    @section = Section.new(section_params)

    respond_to do |format|
      if @section.save
        format.html { redirect_to @section, notice: 'Section was successfully created.' }
        format.json { render :show, status: :created, location: @section }
      else
        format.html { render :new }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sections/1
  # PATCH/PUT /sections/1.json
  def update
    respond_to do |format|
      if params[:commit] == "Save"
        if @section.update(section_params)
          format.html { redirect_to @section, notice: 'Section was successfully updated.' }
          format.json { render :show, status: :ok, location: @section }
          format.js
        else
          format.html { render :edit }
          format.json { render json: @section.errors, status: :unprocessable_entity }
        end
      else
        format.js { render action: "cancel" }
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to sections_url, notice: 'Section was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def cancel
    id = params[:id]
    @section = Section.find_by(id: id)
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:section).permit(:name)
    end
end
