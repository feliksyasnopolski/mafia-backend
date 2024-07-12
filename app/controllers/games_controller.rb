class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new_game
    p params
    render json: {}
  end

  def update_status
    p params
    render json: {}
  end
end