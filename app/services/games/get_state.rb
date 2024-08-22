# frozen_string_literal: true

module Games
  # Gets the state of a game.
  class GetState
    # Initializes a new instance of GetState.
    #
    # @param params [Hash] The parameters for getting the state of a game.
    def initialize(user:, params: {})
      @params = params
      @user = user
    end

    # Gets the state of a game.
    #
    # @return [Hash] The state of the game.
    def call
      p @params
      table = Table.find_by(token: @params[:table_token])
      return nil if table.nil?

      p table

      game = begin
        table.games.in_progress.first
      rescue StandardError
        nil
      end
      return nil if game.nil?

      p game

      JSON.parse(game.info.game_state)
    end
  end
end
