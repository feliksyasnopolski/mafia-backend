# frozen_string_literal: true

module Games
  # Updates the state of a game.
  class UpdateState
    # Initializes a new instance of UpdateState.
    #
    # @param params [Hash] The parameters for updating the state of a game.
    def initialize(params)
      @params = params
    end

    # Updates the state of a game.
    #
    # @return [Hash] The state of the game.
    def call
      table = Table.find_by(token: @params[:table_token])
      return nil if table.nil?

      game = begin
        table.games.in_progress.first
      rescue StandardError
        nil
      end
      return nil if game.nil?

      game.info.game_state = @params[:state].to_json

      game.save
    end
  end
end
