# frozen_string_literal: true

class CreateTables < ActiveRecord::Migration[7.1]
  def change
    create_table :tables do |t|
      t.references :club, null: false, foreign_key: true
      t.string :token

      t.timestamps
    end
  end
end
