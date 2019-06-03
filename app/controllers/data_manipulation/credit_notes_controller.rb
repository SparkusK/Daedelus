module DataManipulation
  class CreditNotesController < AdministrativeController
    before_action :set_credit_note, only: [:show, :edit, :update, :destroy]
    before_action :new_credit_note, only: :new
    before_action :set_credit_notes, only: :index

    private
      def new_credit_note
        @credit_note = CreditNote.new
      end

      def set_credit_note
        @credit_note = CreditNote.find(params[:id])
      end

      def set_credit_notes
        @credit_notes = CreditNote.search(params[:keywords], @dates, params[:page])
      end

      def instance
        @credit_note
      end

      def whitelist_params
        params.require(:credit_note).permit(:creditor_order_id, :payment_type, :amount_paid, :note, :invoice_code)
      end
  end
end
