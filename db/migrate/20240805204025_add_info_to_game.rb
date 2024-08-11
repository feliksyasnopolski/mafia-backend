# frozen_string_literal: true

class AddInfoToGame < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :info, :jsonb, default: {}
  end
end
