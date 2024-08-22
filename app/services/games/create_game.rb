# frozen_string_literal: true

module Games
  # Creates a new game.
  class CreateGame
    # Initializes a new instance of CreateGame.
    #
    # @param params [Hash] The parameters for creating a game.
    def initialize(params)
      @params = params
    end

    # Creates a new game and assigns players to it.
    #
    # @return [Game] The created game.
    def call
      # Game.where(state: %i[pick_roles in_progress]).each(&:finished!)
      table = Table.find_by_token(@params[:table_token])
      p table
      table.games.where(state: %i[pick_roles in_progress]).destroy_all
      game = table.games.create(state: :pick_roles)

      @params[:players].each do |player|
        user = User.find_by(nickname: player[:nickname])
        role = player[:role].to_sym
        number = player[:number]

        game.games_players.create(player: user, role:, number:)
      end
    end
  end
end
