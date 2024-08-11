# frozen_string_literal: true

require 'active_support/concern'

module WithClub
  extend ActiveSupport::Concern

  included do
    scope :with_current_club, -> { where(club: Current.club) }
  end

  # class_methods do
  #   ...
  # end
end
