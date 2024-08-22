# frozen_string_literal: true

module Api
  module V1
    class GamesController < Api::V1::BaseController
      before_action :authenticate_user!

      def new
        p params
        p current_user
        service = Games::CreateGame.new(params)
        service.call

        render json: {}
      end

      def unfinished
        service = Games::Unfinished.new(params:, user: current_user)
        render json: service.call
      end

      def state
        service = Games::GetState.new(params:, user: current_user)
        state = service.call
        render json: { state: }
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

      def save_game
        Games::UpdateState.new(params).call

        render json: {}
      end
    end
  end
end
