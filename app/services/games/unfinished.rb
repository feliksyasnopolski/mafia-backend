# frozen_string_literal: true

module Games
  # Checks if a games is available to resume (on different tables).
  class Unfinished
    # Initializes a new instance of IsGamesAvailable.
    #
    # @param params [Hash] The parameters for checking if a game is available.
    def initialize(user:, params: nil)
      @params = params
      @user = user
    end

    # Checks if a game is available to join.
    #
    # @return [Hash] Array of games available to join in format {table_name: ..., table_token: ..., started_at: ...}.
    def call
      games = Game.for_club(@user.club).in_progress
      return [] if games.empty?

      games.map do |game|
        { table_number: game.table.number, table_token: game.table.token, started_at: game.created_at }
      end
    end
  end
end
