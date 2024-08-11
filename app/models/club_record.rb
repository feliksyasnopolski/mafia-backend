# frozen_string_literal: true

# This class represents a club record.
class ClubRecord < ApplicationRecord
  belongs_to :club
  belongs_to :user

  enum role: { member: 0, admin: 1, invitee: 2 }
end
