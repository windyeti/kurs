class ReviewIntegrationsController < ApplicationController
  before_action :set_integration, only: [:new, :create]
  before_action :set_review_integration, only: [:destroy]

  authorize_resource

  def new
    @review_integration = ReviewIntegration.new
  end

  def create
    @review_integration = @integration.build_review_integration({
                                                                insalesid: current_user.integration.insalesid,
                                                                subdomain: current_user.subdomain
                                                            })
    @review_integration.user = current_user
    if @review_integration.save
      redirect_to current_user.account
    else
      render :new
    end
  end

  def destroy
    @review_integration.destroy
    redirect_to current_user.account
  end

  private

  def set_review_integration
    @review_integration = ReviewIntegration.find(params[:id])
  end
  def set_integration
    @integration = Integration.find(params[:integration_id])
  end
end
