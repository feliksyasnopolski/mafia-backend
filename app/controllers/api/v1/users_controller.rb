# frozen_string_literal: true

module Api
  module V1
    class UsersController < Api::V1::BaseController
      before_action :authenticate_user!

      def index
        users = User.all.where(internal: false)
        users = users.map { |user| { id: user.id, nickname: user.nickname } }
        render json: users
      end
    end
  end
end
