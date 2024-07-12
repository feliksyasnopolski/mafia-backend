class UsersController < ApplicationController
  def index
    users = User.all
    users = users.map { |user| { id: user.id, nickname: user.nickname } }
    render json: users
  end
end