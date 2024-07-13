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
      Game.where(state: [:started, :in_progress]).each(&:finished!)

      game = Game.create(state: :started)

      @params[:players].each do |player|
        user = User.find_by(nickname: player[:nickname])
        role = player[:role].to_sym
        number = player[:number]

        game.games_players.create(player: user, role:, number:)
      end
    end
  end
end
