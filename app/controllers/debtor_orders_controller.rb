class DebtorOrdersController < ApplicationController
  before_action :set_debtor_order, only: [:show, :edit, :update, :destroy]

  # GET /debtor_orders
  # GET /debtor_orders.json
  def index
    @debtor_orders = DebtorOrder.all
  end

  # GET /debtor_orders/1
  # GET /debtor_orders/1.json
  def show
  end

  # GET /debtor_orders/new
  def new
    @debtor_order = DebtorOrder.new
  end

  # GET /debtor_orders/1/edit
  def edit
  end

  # POST /debtor_orders
  # POST /debtor_orders.json
  def create
    @debtor_order = DebtorOrder.new(debtor_order_params)

    respond_to do |format|
      if @debtor_order.save
        format.html { redirect_to @debtor_order, notice: 'Debtor order was successfully created.' }
        format.json { render :show, status: :created, location: @debtor_order }
      else
        format.html { render :new }
        format.json { render json: @debtor_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /debtor_orders/1
  # PATCH/PUT /debtor_orders/1.json
  def update
    respond_to do |format|
      if @debtor_order.update(debtor_order_params)
        format.html { redirect_to @debtor_order, notice: 'Debtor order was successfully updated.' }
        format.json { render :show, status: :ok, location: @debtor_order }
      else
        format.html { render :edit }
        format.json { render json: @debtor_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /debtor_orders/1
  # DELETE /debtor_orders/1.json
  def destroy
    @debtor_order.destroy
    respond_to do |format|
      format.html { redirect_to debtor_orders_url, notice: 'Debtor order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_debtor_order
      @debtor_order = DebtorOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def debtor_order_params
      params.require(:debtor_order).permit(:customer_id, :job_id, :invoice_id, :SA_number, :value_including_tax, :tax_amount, :value_excluding_tax, :still_owed_amount)
    end
end