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

end
