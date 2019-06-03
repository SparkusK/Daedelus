module DataManipulation
  class DebtorPaymentsController < AdministrativeController
    before_action :set_debtor_payment, only: [:show, :edit, :update, :destroy]
    before_action :set_debtor_payments, only: :index
    before_action :new_debtor_payment, only: :new

    private
      def set_debtor_payment
        @debtor_payment = DebtorPayment.find(params[:id])
      end

      def set_debtor_payments
        @debtor_payments = DebtorPayment.search(params[:keywords], @dates, params[:page])
      end

      def new_debtor_payment
        @debtor_payment = DebtorPayment.new
      end

      def instance
        @debtor_payment
      end

      def whitelist_params
        params.require(:debtor_payment).permit(:debtor_order_id, :invoice_id, :payment_amount, :payment_date, :payment_type, :note)
      end
  end
end
