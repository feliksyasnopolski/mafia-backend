# frozen_string_literal: true

class AddStateToGame < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :state, :integer, default: 0
  end
end
