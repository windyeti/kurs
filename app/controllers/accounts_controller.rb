class AccountsController < ApplicationController
  before_action :set_account, only: [:show]
  authorize_resource

  def show

  end

  def set_account
    @account = Account.find(params[:id])
  end
end
