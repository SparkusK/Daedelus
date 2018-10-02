class DebtorPaymentsController < AdministrativeController
  before_action :set_debtor_payment, only: [:show, :edit, :update, :destroy]

  # GET /debtor_payments
  # GET /debtor_payments.json
  def index
    @debtor_payments = DebtorPayment.search(params[:keywords], @start_date, @end_date, params[:page])
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # GET /debtor_payments/1
  # GET /debtor_payments/1.json
  def show
  end

  # GET /debtor_payments/new
  def new
    @debtor_payment = DebtorPayment.new
  end

  # GET /debtor_payments/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /debtor_payments
  # POST /debtor_payments.json
  def create
    @debtor_payment = DebtorPayment.new(debtor_payment_params)
    create_boilerplate(@debtor_payment)
  end

  # PATCH/PUT /debtor_payments/1
  # PATCH/PUT /debtor_payments/1.json
  def update
    respond_to do |format|
      if params[:commit] == "Save"
        if @debtor_payment.update(debtor_payment_params)
          format.html { redirect_to @debtor_payment, notice: 'Debtor payment was successfully updated.' }
          format.json { render :show, status: :ok, location: @debtor_payment }
          format.js
        else
          format.html { render :edit }
          format.json { render json: @debtor_payment.errors, status: :unprocessable_entity }
        end
      else
        format.js { render action: "cancel" }
      end
    end
  end

  # DELETE /debtor_payments/1
  # DELETE /debtor_payments/1.json
  def destroy
    @debtor_payment.destroy
    respond_to do |format|
      format.html { redirect_to debtor_payments_url, notice: 'Debtor payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_debtor_payment
      @debtor_payment = DebtorPayment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def debtor_payment_params
      params.require(:debtor_payment).permit(:debtor_order_id, :invoice_id, :payment_amount, :payment_date, :payment_type, :note)
    end
end
