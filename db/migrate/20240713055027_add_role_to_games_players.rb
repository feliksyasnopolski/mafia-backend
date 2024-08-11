# frozen_string_literal: true

class AddRoleToGamesPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :games_players, :role, :integer
  end
end
