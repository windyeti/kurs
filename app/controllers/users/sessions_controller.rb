class Users::SessionsController < Devise::SessionsController
  before_action :redirect_to_app_url, except: :destroy

  def create
    super
  end

  def destroy
    super
  end

  private

  def redirect_to_app_url
    return if request.subdomain.present? && request.subdomain == 'app'

    url = app_url
    redirect_to url
  end


  def app_url
    subdomain = 'app.'
    # puts request.subdomain.present?
    if request.subdomain.present?
      host = request.host_with_port.sub! "#{request.subdomain}.", ''
    else
      host = request.host_with_port
      # puts host
    end

    # "http://#{subdomain}.#{host}#{request.path}"
    "http://"+"#{subdomain}"+"#{host}"+"#{request.path}"

  end
end
