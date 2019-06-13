module DataManipulation
  class JobTargetsController < AdministrativeController
    before_action :set_job_target, only: [:show, :edit, :update, :destroy, :amounts]
    before_action :set_job_targets, only: :index
    before_action :new_job_target, only: :new

    # GET /job_targets/:id/amounts/:job_id
    def amounts
      job_id = params[:job_id]
      @job_target_amounts = @job_target.amounts(job_id)
      respond_to do |format|
        format.html { render json: @job_target_amounts }
        format.json { render json: @job_target_amounts }
      end
    end

    # GET /job_targets/amounts/:job_id
    def amounts_new
      job_id = params[:job_id]
      @job_target_amounts = JobTarget.amounts_for_new_job_target(job_id)
      respond_to do |format|
        format.html { render json: @job_target_amounts }
        format.json { render json: @job_target_amounts }
      end
    end

    private
      def set_job_target
        @job_target = JobTarget.find(params[:id])
      end

      def set_job_targets
        @dates = Utility::DateRange.new( start_date: params[:target_start_date],
          end_date: params[:target_end_date],
          use_defaults: false
        )
        apply_filters =
            params[:keywords].present? ||
            params[:target_start_date].present? ||
            params[:target_end_date].present? ||
            params[:section_filter_id].present?
        @job_targets = apply_filters ?
          JobTarget.search(
            params[:keywords],
            @dates,
            params[:page],
            params[:section_filter_id]
          ).includes(:job, :section).paginate(page: params[:page]) :
          JobTarget.includes(:job, :section).paginate(page: params[:page])
      end

      def new_job_target
        @job_target = JobTarget.new
      end

      def instance
        @job_target
      end

      def whitelist_params
        params.require(:job_target).permit(
          :target_date,
          :invoice_number,
          :remarks,
          :details,
          :target_amount,
          :section_id,
          :job_id,
          :target_start_date,
          :target_end_date,
          :page,
          :section_filter_id
          )
      end
  end
end
