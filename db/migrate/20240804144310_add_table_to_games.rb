# frozen_string_literal: true

class AddTableToGames < ActiveRecord::Migration[7.1]
  def change
    add_reference :games, :table, null: true, foreign_key: true
  end
end
