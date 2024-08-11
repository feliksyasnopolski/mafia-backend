# frozen_string_literal: true

module Api
  module V1
    class TablesController < Api::V1::BaseController
      before_action :authenticate_user!

      def index
        p current_user
        club = Current.user.club
        @tables = Table.joins(:club).where(clubs: { id: club.id })
        render json: @tables.map do |table|
          {
            id: table.id,
            name: I18n.t('table_with_number', number: table.number),
            token: table.token
          }
        end
      end
    end
  end
end
