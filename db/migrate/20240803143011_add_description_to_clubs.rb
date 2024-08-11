# frozen_string_literal: true

class AddDescriptionToClubs < ActiveRecord::Migration[7.1]
  def change
    add_column :clubs, :description, :string
  end
end
