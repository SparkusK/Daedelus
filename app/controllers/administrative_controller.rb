class AdministrativeController < ApplicationController
  #before_action :authenticate_user!
  before_action :set_dates, only: :index

  def cancel(instance, entity)
    instance = entity.find_by(id: params[:id])
    respond_to { |format| format.js }
  end

  private
    def set_dates
      params[:start_date] = 1.month.ago if params[:start_date].nil?
      params[:end_date] = 0.months.ago if params[:end_date].nil?
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
