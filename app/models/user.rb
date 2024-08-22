# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :omniauthable, :registerable,
         :recoverable, :rememberable, :validatable

  devise :omniauthable, omniauth_providers: %i[google_oauth2]
  include DeviseTokenAuth::Concerns::User
  devise :omniauthable, omniauth_providers: %i[google_oauth2]

  validates_uniqueness_of :nickname, case_sensitive: false
  # validates_presence_of :nickname
  # validates_length_of :nickname, minimum: 3

  # has_and_belongs_to_many :games, join_table: "games_players", foreign_key: "games:game_id"
  has_one_attached :avatar
  has_many :games_players
  has_many :games, through: :games_players
  # belongs_to :club

  has_one :club_record
  has_one :club, through: :club_record
  # has_many :clubs, through: :club_records
  # has_one :current_club, -> { where(club_records: { user_id: id }) }, through: :club_records, source: :club
  # has_one :club, through: :current_club, class_name: 'Club'

  def member_of?(club)
    club.members.include?(self)
  end

  def admin_of?(club)
    club_record = club.club_records.find_by(user_id: id)
    club_record&.admin?
  end

  def invitee_of?(club)
    club_record = club.club_records.find_by(user_id: id)
    club_record&.invitee?
  end

  def club?
    club_record.present? && club_record.role != 'invitee'
  end

  def self.from_google(user)
    u = User.find_by(email: user[:email])
    unless u
      password = SecureRandom.hex(20)
      u = User.create(
        email: user[:email],
        uid: user[:uid],
        provider: 'google_oauth2',
        password:,
        password_confirmation: password
      )
    end

    u
  end
end
