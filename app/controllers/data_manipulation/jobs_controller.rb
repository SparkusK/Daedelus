module DataManipulation
  class JobsController < AdministrativeController
    before_action :set_job, only: [:show, :edit, :update, :destroy]
    before_action :set_jobs, only: :index
    before_action :new_job, only: :new

    private
      def set_job
        @job = Job.find(params[:id])
      end

      def set_jobs
        @target_dates = Utility::DateRange.new( start_date: params[:target_start_date],
          end_date: params[:target_end_date] )
        @receive_dates = Utility::DateRange.new( start_date: params[:receive_start_date],
          end_date: params[:receive_end_date] )
        @jobs = Job.search( keywords: params[:keywords], target_dates: @target_dates,
          receive_dates: @receive_dates, page: params[:page], targets: params[:targets],
          completes: params[:completes], section_filter_id: params[:section_filter_id] )
      end

      def new_job
        @job = Job.new
      end

      def instance
        @job
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def whitelist_params
        params.require(:job).permit( :receive_date,
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
          :client_section,
          :section_filter_id
        )
      end
  end
end
