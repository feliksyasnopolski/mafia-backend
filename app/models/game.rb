# frozen_string_literal: true

# This is the Game class.
class Game < ApplicationRecord
  include WithClub
  enum state: { pick_roles: 0, in_progress: 1, finished: 2 }

  has_many :games_players, dependent: :destroy
  has_many :players, through: :games_players, class_name: 'User'
  belongs_to :table
  has_one :club, through: :table
  has_many :game_logs, dependent: :destroy

  attribute :info, Json::GameInfo.to_type

  scope :finished, -> { where(state: :finished) }
  scope :for_club, ->(club) { joins(:table).where(tables: { club: }) }

  def winner_role
    mafia_count = games_players.mafia.alive.count
    citizens_count = games_players.citizen.alive.count

    if mafia_count.zero?
      'citizen'
    elsif mafia_count >= citizens_count
      'mafia'
    else
      'in_progress'
    end
  end

  def winner_pretty
    winners = {
      'citizen' => 'Победа мирных',
      'mafia' => 'Победа мафии',
      'in_progress' => 'Игра продолжается'
    }
    winners[winner]
  end

  def winner_pretty_class
    winners = {
      'citizen' => 'bg-success',
      'mafia' => 'bg-danger',
      'in_progress' => 'bg-warning'
    }
    winners[winner]
  end

  def set_winner
    game_winner = winner_role
    return unless game_winner != 'in_progress'

    update(state: :finished, winner: game_winner)
  end
end
