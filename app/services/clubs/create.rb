# frozen_string_literal: true

module Clubs
  class Create
    def initialize(params:, user:)
      @params = params
      @user = user
    end

    def call
      club = Club.create!(@params)
      club.club_records.create!(user: @user, role: :admin)
      club.tables.create!(number: 1, token: SecureRandom.hex(10))

      club
    rescue ActiveRecord::RecordInvalid => e
      p e

      nil
    end
  end
end
