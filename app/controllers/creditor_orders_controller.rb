class CreditorOrdersController < AdministrativeController
  before_action :authenticate_user!
  before_action :set_creditor_order, only: [:show, :edit, :update, :destroy]

  # GET /creditor_orders
  # GET /creditor_orders.json
  def index
    @creditor_orders = CreditorOrder.search(params[:keywords], @start_date, @end_date, params[:page])
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # GET /creditor_orders/1
  # GET /creditor_orders/1.json
  def show
  end

  # GET /creditor_orders/new
  def new
    @creditor_order = CreditorOrder.new
  end

  # GET /creditor_orders/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /creditor_orders
  # POST /creditor_orders.json
  def create
    @creditor_order = CreditorOrder.new(creditor_order_params)
    create_boilerplate(@creditor_order)
  end

  # PATCH/PUT /creditor_orders/1
  # PATCH/PUT /creditor_orders/1.json
  def update
    respond_to do |format|
      if params[:commit] == "Save"
        if @creditor_order.update(creditor_order_params)
          format.html { redirect_to @creditor_order, notice: 'Creditor order was successfully updated.' }
          format.json { render :show, status: :ok, location: @creditor_order }
          format.js
        else
          format.html { render :edit }
          format.json { render json: @creditor_order.errors, status: :unprocessable_entity }
          format.js { render 'edit' }
        end
      else
        format.js { render action: "cancel" }
      end
    end
  end

  # DELETE /creditor_orders/1
  # DELETE /creditor_orders/1.json
  def destroy
    @creditor_order.destroy
    respond_to do |format|
      format.html { redirect_to creditor_orders_url, notice: 'Creditor order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  # GET /debtor_orders/1/amounts.json
  def ajax_amounts
    order = CreditorOrder.find_by(id: params[:id])
    owed = order.get_still_owed_amount
    @amounts = {value: order.value_excluding_tax, owed: owed }

    respond_to do |format|
      format.json {
        render json: @amounts
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_creditor_order
      @creditor_order = CreditorOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def creditor_order_params
      params.require(:creditor_order).permit(:supplier_id, :job_id, :delivery_note, :date_issued, :value_excluding_tax, :tax_amount, :value_including_tax, :reference_number)
    end
end
