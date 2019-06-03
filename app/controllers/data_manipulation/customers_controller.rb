module DataManipulation
  class CustomersController < AdministrativeController
    before_action :set_customer, only: [:show, :edit, :update, :destroy]
    before_action :new_customer, only: :new
    before_action :set_customer, only: :index

    private
      def set_customer
        @customer = Customer.find(params[:id])
      end

      def set_customers
        @customers = Customer.search(params[:keywords], params[:page])
      end

      def new_customer
        @customer = Customer.new
      end

      def instance
        @customer
      end

      def whitelist_params
        params.require(:customer).permit(:name, :email, :phone)
      end
  end
end
