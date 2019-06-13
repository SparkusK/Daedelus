module DataManipulation
  class DebtorOrdersController < AdministrativeController
    before_action :set_debtor_order, only: [:show, :edit, :update, :destroy]
    before_action :set_debtor_orders, only: :index
    before_action :new_debtor_order, only: :new

    # GET /debtor_orders/1/amounts.json
    def ajax_amounts
      order = DebtorOrder.find_by(id: params[:id])
      owed = order.still_owed_amount
      @amounts = {value: order.value_excluding_tax, owed: owed }
      respond_to { |format| format.json { render json: @amounts } }
    end

    private
      def set_debtor_order
        @debtor_order = DebtorOrder.find(params[:id])
      end

      def set_debtor_orders
        @debtor_orders = DebtorOrder.search(params[:keywords],
          @dates, params[:page])
      end

      def new_debtor_order
        @debtor_order = DebtorOrder.new
      end

      def instance
        @debtor_order
      end

      def whitelist_params
        params.require(:debtor_order).permit(:customer_id, :job_id,
          :order_number, :value_including_tax, :tax_amount, :value_excluding_tax)
      end
  end
end
