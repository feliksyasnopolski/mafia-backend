# frozen_string_literal: true

class AddIsDeletedToClubRecords < ActiveRecord::Migration[7.1]
  def change
    add_column :club_records, :is_deleted, :boolean
  end
end
