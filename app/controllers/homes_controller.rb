class HomesController < ApplicationController
  skip_before_action :redirect_to_subdomain

  authorize_resource :class => false

  def index
  end

  def manual
  end
end
