class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = params[:keywords].present? ?
      Invoice.search(params[:keywords]).paginate(page: params[:page]) :
      Invoice.paginate(page: params[:page])
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    respond_to do |format|
      if params[:commit] == "Save"
        if @invoice.update(invoice_params)
          format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
          format.json { render :show, status: :ok, location: @invoice }
          format.js
        else
          format.html { render :edit }
          format.json { render json: @invoice.errors, status: :unprocessable_entity }
        end
      else
        format.js { render action: "cancel" }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def cancel
    id = params[:id]
    @invoice = Invoice.find_by(id: id)
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(:code)
    end
end
