class PaymentsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:success, :fail, :result]
  before_action :set_payment, only: [:show, :edit, :update, :destroy]
  # skip_before_action :redirect_to_subdomain
  protect_from_forgery with: :null_session

  skip_authorization_check only: [:success, :fail, :result]

  def index
    # @payments = Payment.all
    @search = Payment.ransack(params[:q])
    @search.sorts = 'id desc' if @search.sorts.empty?
    @payments = @search.result.paginate(page: params[:page], per_page: 30)
  end

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @payment.destroy
    respond_to do |format|
      format.html { redirect_to payments_url, notice: 'Payment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def result
    puts 'result here'
    # TODO для полноценной секюротности можно данные брать из LMI_HASH
    @payments = Payment.where(:user_id => params['CURRENT_USER'], :invoice_id => params['LMI_PAYMENT_NO'] )
    @payments.each do |payment|
      payment.update(:status => 'Оплачен', :paymentdate => params['LMI_SYS_PAYMENT_DATE'], :paymentid => params['LMI_SYS_PAYMENT_ID'])
    end

    redirect_to dashboard_index_path
  end

  def success
    puts 'success here'
    @user = User.find(params[:CURRENT_USER])
    sign_in(:user, @user)
    redirect_to after_sign_in_path_for(@user), notice: "Платеж принят"
  end

  def fail
    puts 'fail here'
    @user = User.find(params[:CURRENT_USER])
    sign_in(:user, @user)
    redirect_to after_sign_in_path_for(@user), alert: "Ошибка платежа"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_payment
    @payment = Payment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def payment_params
    params.require(:payment).permit(:user_id, :invoice_id, :payplan_id, :status, :paymenttype, :paymentdate, :paymentid)
  end
end
