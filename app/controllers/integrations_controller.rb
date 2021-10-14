class IntegrationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:install, :login]
  authorize_resource

  def index

  end

  def new
    @integration = Integration.new
  end

  def create
    @integration = current_user.build_integration(integration_params)
    @integration.status = true
    if @integration.save
      redirect_to current_user.account
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def install
    @integration = Integration.find_by(insalesid: params[:insales_id])
    if @integration.present?
      puts "есть пользователь"
    else
      save_subdomain = "insales"+params[:insales_id]
      email = save_subdomain+"@mail.ru"
      user = User.create({
                           name: params[:insales_id],
                           subdomain: save_subdomain,
                           password: save_subdomain,
                           password_confirmation: save_subdomain,
                           email: email
                         })
      # TODO надо записать в кредентиалс секретный ключ из настроек приложения в инсайлс
      secret_key = Rails.application.credentials[:secret_key]
      # secret_key = ENV["INS_APP_SECRET_KEY"]
      password = Digest::MD5.hexdigest(params[:token] + secret_key)
      user.create_integration({
                                subdomen: params[:shop],
                                password: password,
                                insalesid: params[:insales_id],
                                status: true
                              })
      head :ok
    end
  end

  def login
    @integration = Integration.find_by(insalesid: params[:insales_id])
    user = @integration.user
    if @integration.present?
        sign_in(:user, user)
        redirect_to after_sign_in_path_for(user)
    end
  end

  private

  def integration_params
    params.require(:integration).permit(:inskey, :password, :subdomain)
  end
end
