# frozen_string_literal: true

# This controller handles user-related actions.
class UsersController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  def index
    users = User.all.where(internal: false)
    users = users.map { |user| { id: user.id, nickname: user.nickname } }
    render json: users
  end

  def edit
    @user = Current.user
  end

  def update
    @user = Current.user
    begin
      Users::UpdateUser.call(@user, user_params)
      if params["user"]["redirect_home"].blank?
        redirect_to edit_user_path, notice: 'User was successfully updated.'
      else
        redirect_to root_path
      end
    rescue StandardError
      @user.reload
      p @user.errors.full_messages
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :password, :password_confirmation, :current_password, :avatar)
  end
end
