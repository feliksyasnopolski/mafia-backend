class ApplicationController < ActionController::Base
  add_flash_types :info, :error, :success
  before_action :set_current_user, if: :user_signed_in?
  before_action :set_current_club
  layout :layout_by_resource

  private

  def layout_by_resource
    if devise_controller?
      p 'devise'
      'devise'
    else
      'application'
    end
  end

  def set_current_user
    Current.user = current_user
  end

  def set_current_club
    token = request.subdomain || params[:token]
    Current.club = Club.find_by_token(token)
  end
end
