# frozen_string_literal: true

class AddInternalToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :internal, :boolean, default: false
  end
end
