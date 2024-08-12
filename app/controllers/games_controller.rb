# frozen_string_literal: true

class GamesController < ApplicationController
  APP_ACTIONS = %i[new_game update_status update_log update_votes stop current_state_obs].freeze

  before_action :authenticate_user!, except: APP_ACTIONS
  skip_before_action :verify_authenticity_token, only: APP_ACTIONS
  before_action :set_game, only: %i[show edit update destroy]

  # GET /games or /games.json
  def index
    @games = Game.includes(:games_players).where.not(games_players: { id: nil }).finished.order(created_at: :desc)
  end

  def my
    @games = Game.includes(:players).where(players: { id: Current.user.id },
                                           games: { state: :finished }).order(created_at: :desc)

    render :index
  end

  def new_game
    # p params
    service = Games::CreateGame.new(params)
    service.call

    render json: {}
  end

  def update_status
    service = Games::UpdatePlayers.new(params)
    service.call
    render json: {}
  end

  def current_state_obs
    @table = Table.find_by_token(params[:token])
    @players = begin
      @table.games.last.games_players.includes(:player).order(:number)
    rescue StandardError
      nil
    end
    render :current_state_obs, layout: false
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
    render json: {}
  end

  def show
    @players = @game.games_players.includes(:player).order(:number)
    respond_to do |format|
      format.html { render :show }
      format.json do
        game_json = {
          id: @game.id,
          players: @players.map do |player|
            {
              id: player.id,
              number: player.number,
              role: player.role_pretty,
              alive: player.alive,
              nickname: player.player.nickname,
              avatar: player.player.avatar.attached? ? url_for(player.player.avatar) : nil
            }
          end,
          logs: @game.game_logs.order(:created_at).map do |log|
            {
              log_record: log.log_record,
              created_at: log.created_at
            }
          end,
          winner: @game.winner_pretty
        }

        render json: game_json
      end
    end
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit; end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to game_url(@game), notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to game_url(@game), notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy!

    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def game_params
    params.require(:game).permit(:winner)
  end
end
