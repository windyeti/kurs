class PayplansController < ApplicationController
  before_action :set_payplan, only: [:show, :edit, :update, :destroy]

  authorize_resource

  def index
    @payplans = Payplan.all
  end

  def show; end

  def new
    @payplan = Payplan.new
  end

  def create
    @payplan = Payplan.new(payplan_params)

    if @payplan.save
      redirect_to payplans_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @payplan.update(payplan_params)
      redirect_to @payplan
    else
      render :edit
    end
  end

  def destroy
    @payplan.destroy
    redirect_to payplans_path
  end

  private

  def set_payplan
    @payplan = Payplan.find(params[:id])
  end

  def payplan_params
    params.require(:payplan).permit(:period, :price, :for)
  end
end
