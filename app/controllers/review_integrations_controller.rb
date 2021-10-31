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

    @review_integration = ReviewIntegration.find_by_subdomain(params[:host])

    if @review_integration.status
      @integration = @review_integration.integration
      @url_domain = Services::Insales::UrlDomain.new(@integration).call


      @reviews_with_image = get_reviews_wtih_image
      render json: { reviews: @reviews_with_image, success: true }
    end
  end

  private

  def get_reviews_wtih_image
    reviews = api_get_reviews
    reviews.map do |review|
      product = api_get_products(review["product_id"])
      image_first = api_get_image(product)
      review['product_title'] = product['title']
      review['product_image'] = image_first['thumb_url']
    end
  end

  def api_get_image(product)
    uri = "#{@url_domain}/admin/products/#{product['id']}/images/#{product['images'].first['id']}.json"

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
  def api_get_reviews
    uri = "#{@url_domain}/admin/reviews.json"

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

  def api_get_products(id)
    uri = "#{@url_domain}/admin/products/#{id}.json"

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
