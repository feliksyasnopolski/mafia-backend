# frozen_string_literal: true

module Json
  # Represents game information in JSON format.
  class GameInfo
    include StoreModel::Model

    attribute :proposed_players, :array_of_integer, default: []
    attribute :killed_players, :array_of_integer, default: []
    attribute :don_checks, :array_of_integer, default: []
    attribute :sheriff_checks, :array_of_integer, default: []
    attribute :best_moves, :array_of_integer, default: []
    attribute :first_killed_player, :integer
    attribute :game_state, :string
  end
end
