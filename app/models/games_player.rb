# frozen_string_literal: true

# Represents the association between a game and a player in the Mafia game.
class GamesPlayer < ApplicationRecord
  enum role: { citizen: 0, mafia: 1, godfather: 2, sheriff: 3 }

  belongs_to :game
  belongs_to :player, class_name: 'User'

  # Checks if the player is part of the mafia team.
  #
  # @return [Boolean] true if the player is mafia or godfather, false otherwise.
  def is_mafia? # rubocop:disable Naming/PredicateName
    mafia? || godfather?
  end

  # Checks if the player is a citizen.
  #
  # @return [Boolean] true if the player is citizen or sheriff, false otherwise.
  def is_citizen? # rubocop:disable Naming/PredicateName
    citizen? || sheriff?
  end
end
