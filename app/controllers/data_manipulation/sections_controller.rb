module DataManipulation
  class SectionsController < AdministrativeController
    before_action :set_section, only: [:show, :edit, :update, :destroy]
    before_action :set_sections, only: :index
    before_action :new_section, only: :new

    private
      def set_section
        @section = Section.find(params[:id])
      end

      def set_section
        @sections = params[:keywords].present? ?
          Section.search(params[:keywords]).includes(manager: :employee).paginate(page: params[:page]) :
          Section.includes(manager: :employee).paginate(page: params[:page])
      end

      def new_section
        @section = Section.new
      end

      def instance
        @section
      end

      def whitelist_params
        params.require(:section).permit(:name, :overheads)
      end
  end
end
