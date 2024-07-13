class Game < ApplicationRecord
  enum state: { started: 0, in_progress: 1, finished: 2 }

  has_many :games_players
  has_many :players, through: :games_players, class_name: 'User'
end
