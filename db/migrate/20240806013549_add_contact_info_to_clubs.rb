# frozen_string_literal: true

class AddContactInfoToClubs < ActiveRecord::Migration[7.1]
  def change
    add_column :clubs, :contact_info, :string
  end
end
