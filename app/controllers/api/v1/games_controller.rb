# frozen_string_literal: true

module Api
  module V1
    class GamesController < Api::V1::BaseController
      before_action :authenticate_user!

      def new_game
        p params
        p current_user
        service = Games::CreateGame.new(params)
        service.call

        render json: {}
      end

      def update_status
        service = Games::UpdatePlayers.new(params)
        service.call
        render json: {}
      end

      def update_log
        Games::WriteLog.new(params).call
        render json: {}
      end

      def update_votes
        p params
        render json: {}
      end

      def stop
        p params
        p current_user
        render json: {}
      end
    end
  end
end
