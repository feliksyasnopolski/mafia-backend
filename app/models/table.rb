# frozen_string_literal: true

class Table < ApplicationRecord
  belongs_to :club
  has_many :games

  before_save :set_token

  private

  def set_token
    self.token = SecureRandom.uuid
  end
end
