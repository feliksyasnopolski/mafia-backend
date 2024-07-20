class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  validates_uniqueness_of :nickname, case_sensitive: false
  validates_presence_of :nickname
  validates_length_of :nickname, :minimum => 3

  # has_and_belongs_to_many :games, join_table: "games_players", foreign_key: "games:game_id"
  has_one_attached :avatar
  has_many :games_players
  has_many :games, through: :games_players
  belongs_to :club
end
