# frozen_string_literal: true

class AddNumberToTables < ActiveRecord::Migration[7.1]
  def change
    add_column :tables, :number, :integer
  end
end
