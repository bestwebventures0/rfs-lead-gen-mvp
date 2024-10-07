class DashboardController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!

  def thankyou
    # @user = current_user
  end

  def advisors

  end

  def answers
    
  end
end
