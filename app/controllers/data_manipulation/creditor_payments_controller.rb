module DataManipulation
  class CreditorPaymentsController < AdministrativeController
    before_action :set_creditor_payment, only: [:show, :edit, :update, :destroy]
    before_action :new_creditor_payment, only: :new
    before_action :set_creditor_payments, only: :index

    private
      def new_creditor_payment
        @creditor_payment = CreditorPayment.new
      end

      def set_creditor_payment
        @creditor_payment = CreditorPayment.find(params[:id])
      end

      def set_creditor_payments
        @creditor_payments = CreditorPayment.search(params[:keywords], @dates, params[:page])
      end

      def instance
        @creditor_payment
      end

      def whitelist_params
        params.require(:creditor_payment).permit(:creditor_order_id, :payment_type, :amount_paid, :note, :invoice_code)
      end
  end
end
