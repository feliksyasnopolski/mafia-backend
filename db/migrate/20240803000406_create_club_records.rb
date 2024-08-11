# frozen_string_literal: true

class CreateClubRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :club_records do |t|
      t.references :club, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :role

      t.timestamps
    end
  end
end
