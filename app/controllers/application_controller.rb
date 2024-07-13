class ApplicationController < ActionController::Base
  add_flash_types :info, :error, :success
  before_action :set_current_user, if: :user_signed_in?

  private

  def set_current_user
    Current.user = current_user
  end
end
