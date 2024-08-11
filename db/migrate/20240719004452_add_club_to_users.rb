# frozen_string_literal: true

class AddClubToUsers < ActiveRecord::Migration[7.1]
  def change
    add_reference :users, :club, null: true, foreign_key: true
  end
end
