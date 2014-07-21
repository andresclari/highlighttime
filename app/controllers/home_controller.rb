class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:personal]

  def index
    if current_user
      redirect_to personal_url
    end
  end

  def personal
  end
end
