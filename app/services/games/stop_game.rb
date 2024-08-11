# frozen_string_literal: true

module Games
  # Creates a new game.
  class StopGame
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
      table = Table.find_by_token(@params[:table_token])
      table.games.each(&:finished!)
    end
  end
end
