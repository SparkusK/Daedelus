module DataManipulation
  class ManagersController < AdministrativeController
    before_action :set_manager, only: [:show, :edit, :update, :destroy]
    before_action :set_managers, only: :index
    before_action :new_manager, only: :new

    private
      def set_manager
        @manager = Manager.find(params[:id])
      end

      def set_managers
        @managers = params[:keywords].present? ?
          Manager.search(params[:keywords]).includes(:employee, :section).paginate(page: params[:page]) :
          Manager.includes(:employee, :section).paginate(page: params[:page])
      end

      def new_manager
        @manager = Manager.new
      end

      def instance
        @manager
      end

      def whitelist_params
        params.require(:manager).permit(:employee_id, :section_id)
      end
  end
end
