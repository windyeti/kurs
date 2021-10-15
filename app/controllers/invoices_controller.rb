class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invoiceable, only: [:new, :create]
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

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
      @payment = @invoice.build_payment(
        paymenttype: @invoice.paymenttype
      )
      @payment.user = current_user
      @payment.payplan = @invoice.payplan
      @payment.subdomain = current_user.subdomain
      @payment.save
      redirect_to @invoice
    else
      render :new
    end
  end

  def edit; end

  def update
    if @invoice.update(invoice_params)
      redirect_to @invoice
    else
      render :edit
    end
  end

  def destroy
    @invoice.destroy
    redirect_to current_user.account
  end
  # TODO настроить печать инвойса
  def print
    # @company = Company.first
    # @invoice = Invoice.find(params[:invoice_id])
    # respond_to do |format|
    #   format.html
    #   format.pdf do
    #     render :pdf => "Счёт #{@invoice.id}",
    #            :template => "invoices/pdfsight",
    #            :show_as_html => params.key?('debug')
    #   end
    # end
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
    params.require(:invoice).permit(:payertype, :paymenttype, :payplan_id, :status, :sum)
  end
end
