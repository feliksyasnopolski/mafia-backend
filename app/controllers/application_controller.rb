# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # include DeviseTokenAuth::Concerns::SetUserByToken
  add_flash_types :info, :error, :success
  before_action :set_current_user, if: :user_signed_in?
  before_action :set_current_club
  layout :layout_by_resource

  protect_from_forgery with: :null_session, if: -> { request.format.json? }

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
    if Current.user
      Current.club = Current.user.club
    else
      token = request.subdomain || params[:token]
      Current.club = Club.find_by_token(token)
    end
  end
end
