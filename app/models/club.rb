# frozen_string_literal: true

# Represents a club in the application.
class Club < ApplicationRecord
  has_many :club_records
  has_many :tables
  has_many :members, -> { where.not(club_records: { role: 'invitee' }) }, through: :club_records, source: :user
  has_many :invitees, -> { where(club_records: { role: 'invitee' }) }, through: :club_records, source: :user

  has_one_attached :logo

  def accept(user)
    club_records.find_by(user:).member!
    ClubRecord.where(user:).where.not(club: self).invitee.destroy_all
  end

  def reject(user)
    club_records.find_by(user:).destroy
  end

  def invite(user)
    club_records.create(user:, role: :invitee)
  end

  def admin?(user)
    club_records.find_by(user:)&.admin?
  end

  def promote(user)
    club_records.find_by(user:).admin!
  end

  def demote(user)
    club_records.find_by(user:).member!
  end
end
