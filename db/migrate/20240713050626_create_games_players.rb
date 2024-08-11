# frozen_string_literal: true

class CreateGamesPlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :games_players do |t|
      t.references :game, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
