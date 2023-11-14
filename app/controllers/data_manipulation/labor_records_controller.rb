module DataManipulation
  class LaborRecordsController < AdministrativeController
    before_action :set_labor_record, only: [:show, :edit, :update, :destroy]
    before_action :set_labor_records, only: :index
    before_action :new_date, only: :new

    def update
      respond_to do |format|
        if params[:commit] == "Save"
          if @labor_record.update(labor_record_params)
            format.json { render :show, status: :ok, location: @labor_record }
            format.js
          else
            format.json { render json: @labor_record.errors, status: :unprocessable_entity }
            format.js { render 'edit' }
          end
        else
          format.js { render action: "cancel" }
          format.html do
            if @labor_record.update(labor_record_params)
              redirect_to @labor_record, notice: 'Labor record was successfully updated.'
            else
              format.html { render :edit }
            end
          end
        end
      end
    end

    def modal_labor_record
      @labor_record = LaborRecord.find_by(
        employee_id: params[:employee_id],
        labor_date: params[:labor_date]
      )
      respond_to do |format|
        format.js
      end
    end

    private
      def set_labor_record
        @labor_record = LaborRecord.find(params[:id])
      end

      def set_labor_records
        @labor_records = LaborRecord.search( { keywords: params[:keywords], dates: @dates,
          page: params[:page], section_filter_id: params[:section_filter_id] } )
      end

      def new_labor_record
        @labor_record = LaborRecord.new
      end

      def instance
        @labor_record
      end

      def whitelist_params
        params.require(:labor_record).permit(:employee_id, :labor_date, :hours,
          :normal_time_amount_before_tax, :normal_time_amount_after_tax,
          :overtime_amount_before_tax, :overtime_amount_after_tax,
          :sunday_time_amount_before_tax, :sunday_time_amount_after_tax,
          :section_id, :job_id,
          :start_date, :end_date, :page, :section_filter_id
        )
      end

  end
end
