# frozen_string_literal: true

class AddLocationToClubs < ActiveRecord::Migration[7.1]
  def change
    add_column :clubs, :location, :string
  end
end
