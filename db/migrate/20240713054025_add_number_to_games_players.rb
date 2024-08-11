# frozen_string_literal: true

class AddNumberToGamesPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :games_players, :number, :integer
  end
end
