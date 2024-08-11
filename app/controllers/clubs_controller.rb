# frozen_string_literal: true

class ClubsController < ApplicationController
  before_action :set_club, except: %i[index new create]

  # GET /clubs or /clubs.json
  def index
    @clubs = Club.all
  end

  # GET /clubs/1 or /clubs/1.json
  def show; end

  def leave
    @club.members.delete(Current.user)

    redirect_to clubs_path
  end

  def join
    @club.club_records.create(user: Current.user, role: :invitee)

    redirect_to clubs_path
  end

  def accept
    @club.accept(User.find(params[:user_id]))
    render 'clubs/details/manage/invitees'
  end

  def reject
    @club.reject(User.find(params[:user_id]))
    render 'clubs/details/manage/invitees'
  end

  def demote_member
    @club.demote(User.find(params[:user_id]))
    render 'clubs/details/members'
  end

  def promote_member
    @club.promote(User.find(params[:user_id]))
    render 'clubs/details/members'
  end

  def delete_member
    @club.members.delete(User.find(params[:user_id]))
    render 'clubs/details/members'
  end

  def leave_admin
    @club.demote(Current.user)
    render 'clubs/details/members'
  end

  def manage_invitees
    @invitees = @club.club_records.where(role: :invitee)

    render 'clubs/details/manage/invitees'
  end

  def general
    render 'clubs/details/general'
  end

  def members
    @club_records = @club.club_records.where.not(role: :invitee)

    render 'clubs/details/members'
  end

  def games
    @games = Game.for_club(@club).finished

    render 'clubs/details/games'
  end

  def tables
    @tables = @club.tables

    render 'clubs/details/tables'
  end

  # GET /clubs/new
  def new
    @club = Club.new
  end

  # GET /clubs/1/edit
  def edit; end

  # POST /clubs or /clubs.json
  def create
    @club = Clubs::Create.new(params: club_params, user: Current.user).call

    respond_to do |format|
      if @club.save
        format.html { redirect_to club_url(@club), notice: 'Club was successfully created.' }
        format.json { render :show, status: :created, location: @club }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clubs/1 or /clubs/1.json
  def update
    respond_to do |format|
      if @club.update(club_params)
        format.html { redirect_to club_url(@club), notice: 'Club was successfully updated.' }
        format.json { render :show, status: :ok, location: @club }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clubs/1 or /clubs/1.json
  def destroy
    @club.destroy!

    respond_to do |format|
      format.html { redirect_to clubs_url, notice: 'Club was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_club
    @club = Club.find(params[:id])
    @club_records = @club.club_records.where.not(role: :invitee)
  end

  # Only allow a list of trusted parameters through.
  def club_params
    params.require(:club).permit(:name, :description, :logo, :location)
  end
end
