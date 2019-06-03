module DataManipulation
  class CreditorOrdersController < AdministrativeController
    before_action :set_creditor_order, only: [:show, :edit, :update, :destroy]
    before_action :new_creditor_order, only: :new
    before_action :set_creditor_orders, only: :index

    # GET /debtor_orders/1/amounts.json
    def ajax_amounts
      order = CreditorOrder.find_by(id: params[:id])
      owed = order.get_still_owed_amount
      @amounts = { value: order.value_excluding_tax, owed: owed }
      respond_to { |format| format.json { render json: @amounts } }
    end

    private

      def set_creditor_order
        @creditor_order = CreditorOrder.find(params[:id])
      end

      def set_creditor_orders
        @creditor_orders = CreditorOrder.search(
          params[:keywords], @dates, params[:page],
          params[:section_filter_id]
        )
      end

      def new_creditor_order
        @creditor_order = CreditorOrder.new
      end

      def instance
        @creditor_order
      end

      def whitelist_params
        params.require(:creditor_order).permit(:supplier_id, :job_id,
          :delivery_note, :date_issued, :value_excluding_tax, :tax_amount,
          :value_including_tax, :reference_number, :section_filter_id
        )
      end
  end
end
