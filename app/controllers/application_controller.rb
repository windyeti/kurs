class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_to_subdomain
  before_action :allow_cross_domain_ajax
  check_authorization unless: :devise_controller?

  # TODO А без этого будет работать ответ?
  def allow_cross_domain_ajax
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Request-Method'] = 'GET, POST, OPTIONS'
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message  }
      format.js { render status: :forbidden }
      format.json { render json: { message: exception.message }, status: :forbidden }
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :name, :subdomain)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :name, :subdomain)}
  end

  private

  def after_sign_in_path_for(resource_or_scope)
    puts resource_or_scope.subdomain + " - это из ApplicationController - after_sign_in_path_for"
    # root_path
    dashboard_index_url(subdomain: resource_or_scope.subdomain)
  end # after _sign_in_path_for

  def after_sign_out_path_for(resource_or_scope)
    url = request.host_with_port.gsub("#{request.subdomain}","app")
    "http://"+url
  end

  def invoice_path_for(resource_or_scope)
    invoices_url(subdomain: resource_or_scope.subdomain)
  end # invoice_path_for

  def redirect_to_subdomain
    return if self.is_a?(DeviseController)

    if request.subdomain.present?
      if current_user.present? && request.subdomain != current_user.subdomain
        subdomain = current_user.subdomain
        host = request.host_with_port.sub!("#{request.subdomain}", subdomain)
        redirect_to "http://#{host}#{request.path}"
      end
    end
  end # redirect_to_subdomain


  def redirect_to_app_url
    return if request.subdomain.present? && request.subdomain == 'app'

    url = app_url
    redirect_to url

  end # redirect_to_app_url


  def app_url
    subdomain = 'app.'
    # puts request.subdomain.present?
    if request.subdomain.present?
      host = request.host_with_port.sub! "#{request.subdomain}.", ''
    else
      host = request.host_with_port
      # puts host
    end # if

    # "http://#{subdomain}.#{host}#{request.path}"
    "http://"+"#{subdomain}"+"#{host}"+"#{request.path}"

  end # app_url


  # def redirect_to_dashboard
  #   if current_user
  #     redirect_to dashboard_index_url(subdomain: current_user.subdomain) if request.subdomain != current_user.subdomain
  #   end
  # end

  # def after_sign_in_path_for(resource_or_scope)
  #   puts resource_or_scope.subdomain + " - это из ApplicationController - after_sign_in_path_for"
  #   dashboard_index_url(subdomain: resource_or_scope.subdomain)
  # end # after_sign_in_path_for
  #
  # def after_sign_out_path_for(_)
  #   port = request.host_with_port.split(":").count == 2 ? ":#{request.host_with_port.split(":").last}" : ""
  #  "#{request.protocol}.#{request.domain}#{port}"
  # end

end
