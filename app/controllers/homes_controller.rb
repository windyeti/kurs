class HomesController < ApplicationController
  # before_action :redirect_to_app_url

  authorize_resource :class => false

  def index
  end

  def manual
  end
end
