# frozen_string_literal: true

class RemoveClubFromGames < ActiveRecord::Migration[7.1]
  def change
    remove_reference :games, :club, null: false, foreign_key: true
  end
end
