class InvoicesController < ApplicationController
  before_action :set_invoiceable, only: [:new, :create]
  before_action :set_invoice, only: [:show, :edit]
  authorize_resource

  def index
    @invoices = Invoice.all
  end

  def show; end

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = @invoiceable.build_invoice(invoice_params)
    payplan = Payplan.find(invoice_params[:payplan_id])
    @invoice.sum = payplan.price
    @invoice.user = current_user
    if @invoice.save
    #   TODO cоздать Payment или в after_create ????
    redirect_to @invoice
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def print
  end

  private

  def set_invoiceable
    @invoiceable = name.classify.constantize.find(params["#{name.singularize}_id".to_sym])
  end

  def name
    params[:default][:invoiceable]
  end

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:payertype, :paymenttype, :payplan_id)
  end
end
