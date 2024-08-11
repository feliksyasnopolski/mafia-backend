# frozen_string_literal: true

module Users
  class UpdateUser
    def self.call(user, params)
      new(user, params).call
    end

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      params.delete(:password) if params[:password].blank?
      current_password = params.delete(:current_password)
      new_password = params.delete(:password)
      new_password_confirmation = params.delete(:password_confirmation)
      user.assign_attributes(params)

      if current_password && user.valid_password?(current_password)
        user.password = new_password
        user.password_confirmation = new_password_confirmation
      end

      raise user unless user.save

      user
    end

    private

    attr_reader :user, :params
  end
end
