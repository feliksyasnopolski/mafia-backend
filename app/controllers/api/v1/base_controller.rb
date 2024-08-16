# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include DeviseTokenAuth::Concerns::SetUserByToken
      before_action :set_current_user, if: :user_signed_in?
      # skip_before_action :verify_authenticity_token
      # Add your shared API controller logic here

      def set_current_user
        Current.user = current_user
      end
    end
  end
end
