module DataManipulation
  class SuppliersController < AdministrativeController
    before_action :set_supplier, only: [:show, :edit, :update, :destroy]
    before_action :set_suppliers, only: :index
    before_action :new_supplier, only: :new

    private
      def set_supplier
        @supplier = Supplier.find(params[:id])
      end

      def set_suppliers
        @suppliers = params[:keywords].present? ?
          Supplier.search(params[:keywords]).paginate(page: params[:page]) :
          Supplier.paginate(page: params[:page])
      end

      def set_supplier
        @supplier = Supplier.new
      end

      def instance
        @supplier
      end

      def whitelist_params
        params.require(:supplier).permit(:name, :email, :phone)
      end
  end
end
