# frozen_string_literal: true

class CreateGameLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :game_logs do |t|
      t.references :game, null: false, foreign_key: true
      t.string :log_record

      t.timestamps
    end
  end
end
