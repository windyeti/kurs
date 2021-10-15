class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token, if: :devise_controller?
  # before_action :redirect_to_dashboard
  check_authorization unless: :devise_controller?

  # TODO А без этого будет работать ответ?
  before_action :allow_cross_domain_ajax
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

  # def redirect_to_dashboard
  #   if current_user
  #     redirect_to dashboard_index_url(subdomain: current_user.subdomain) if request.subdomain != current_user.subdomain
  #   end
  # end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :name, :subdomain)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :name, :subdomain)}
  end

  private

  def after_sign_in_path_for(resource_or_scope)
    puts resource_or_scope.subdomain + " - это из ApplicationController - after_sign_in_path_for"
    dashboard_index_url(subdomain: resource_or_scope.subdomain)
  end # after_sign_in_path_for

  def after_sign_out_path_for(_)
    port = request.host_with_port.split(":").count == 2 ? ":#{request.host_with_port.split(":").last}" : ""
    request.protocol+request.domain+port
  end

end
