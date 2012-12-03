class Admin::PlayersController < ApplicationController
  def show
    @player = Player.find(params[:id])
    redirect_to(edit_admin_player_url(@player))
  end

  def index
    redirect_to(players_admin_game_url(@default_game))
  end

  def edit
    @player = Player.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.name = params[:name]
    @game.announcements = params[:announcements]
    @game.save()
    flash[:notice] = 'Saved!'
    render :edit
  end

  def new; end
  def create; end
end
