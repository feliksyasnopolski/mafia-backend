# frozen_string_literal: true

class AddTokenToClub < ActiveRecord::Migration[7.1]
  def change
    add_column :clubs, :token, :string
  end
end
