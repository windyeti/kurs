class HomesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:index, :manual]

  authorize_resource :class => false

  def index
  end

  def manual
  end
end
