class GamesController < ApplicationController
  APP_ACTIONS = %i[ new_game update_status update_log update_votes stop current_state_obs] 

  before_action :authenticate_user!, except: APP_ACTIONS
  skip_before_action :verify_authenticity_token, only: APP_ACTIONS
  before_action :set_game, only: %i[ show edit update destroy ]

  # GET /games or /games.json
  def index
    @games = Game.all
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
    @players = Game.where(state: [:started, :in_progress]).last.games_players.includes(:player).order(:number)
    render :current_state_obs, layout: false
  end

  def update_log
    p params
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

  # GET /games/1 or /games/1.json
  def show
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to game_url(@game), notice: "Game was successfully created." }
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
        format.html { redirect_to game_url(@game), notice: "Game was successfully updated." }
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
      format.html { redirect_to games_url, notice: "Game was successfully destroyed." }
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
