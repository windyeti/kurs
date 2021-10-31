class ReviewIntegrationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :set_integration, only: [:new, :create, :get_reviews]
  before_action :set_review_integration, only: [:destroy]

  authorize_resource

  def new
    @review_integration = ReviewIntegration.new
  end

  def create
    @review_integration = @integration.build_review_integration({
                                                                insalesid: current_user.integration.insalesid,
                                                                subdomain: @integration.subdomain
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

  def get_reviews
    # data =
    #   {
    #   "my_answer": "KOKOKO"
    #   }
    # render json: { data: data, success: true }


    @review_integration = ReviewIntegration.find_by_subdomen(params[:host])
    if @review_integration.status
      pp @reviews = api_get_reviews(@review_integration.integration)
      # render json: { reviews: @reviews, success: true }
    end
  end

  private

  def api_get_reviews(integration)
    url_domain = Services::Insales::UrlDomain.new(integration).call
    uri = "#{url_domain}/admin/reviews.json"

    RestClient.get( uri, :accept => :json, :content_type => "application/json") do |response, request, result, &block|
      case response.code
      when 200
        JSON.parse response.body
      when 422
        puts "error 422"
        puts response
      when 404
        puts 'error 404'
        puts response
      when 503
        sleep 1
        puts 'sleep 1 error 503'
      else
        response.return!(&block)
      end
    end
  end

  def set_review_integration
    @review_integration = ReviewIntegration.find(params[:id])
  end
  def set_integration
    @integration = Integration.find(params[:integration_id])
  end
end
