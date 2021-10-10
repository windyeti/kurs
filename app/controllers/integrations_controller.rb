class IntegrationsController < ApplicationController
  authorize_resource

  def new
    @integration = Integration.new
  end

  def create
    @integration = current_user.build_integration
    if @integration.save
      redirect_to current_user.account
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
end
