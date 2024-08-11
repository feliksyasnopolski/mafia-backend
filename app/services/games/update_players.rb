# frozen_string_literal: true

module Games
  class UpdatePlayers
    # Updates the players' status in a game.
    #
    # @param params [Hash] The parameters containing the players' information.
    def initialize(params)
      @params = params
    end

    # Updates the players' status in the game.
    def call
      game = Table.find_by_token(@params[:table_token]).games.last
      game.in_progress! if game.pick_roles?

      @params[:players].each do |player|
        game_player = game.games_players.find_by(player: User.find_by(nickname: player[:nickname]))
        game_player.update(alive: player[:alive])
      end
    end
  end
end
