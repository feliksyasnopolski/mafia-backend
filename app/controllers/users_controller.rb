class UsersController < ApplicationController
  def index
    users = User.all.where(internal: false)
    users = users.map { |user| { id: user.id, nickname: user.nickname } }
    render json: users
  end
end