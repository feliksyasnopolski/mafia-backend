# frozen_string_literal: true

class AddAliveToGamesPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :games_players, :alive, :boolean, default: true
  end
end
