class AdministrativeController < ApplicationController

  def set_index(entity, included)
    if params[:keywords].present?
      entity.search(params[:keywords]).includes(included).paginate(page: params[:page])
    else
      entity.includes(included).paginate(page: params[:page])
    end
  end

  def cancel(instance, entity)
    instance = entity.find_by(id: params[:id])
    respond_to { |format| format.js }
  end

  private

  def create_boilerplate(entity)
    respond_to do |format|
      if entity.save
        format.html { redirect_to entity, notice: "#{entity} was successfully created." }
        format.json { render :show, status: :created, location: entity }
      else
        format.html { render :new }
        format.json { render json: entity.errors, status: :unprocessable_entity }
      end
    end
  end

end
