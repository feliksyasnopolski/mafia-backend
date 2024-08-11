# frozen_string_literal: true

class AddClubToGames < ActiveRecord::Migration[7.1]
  def change
    add_reference :games, :club, null: true, foreign_key: true
  end
end
