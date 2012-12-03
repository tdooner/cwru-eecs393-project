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
    @squads = Game.find(@player.game_id).squads
  end

  def update
    @player = Player.find(params[:id])
    @player.attributes = params[:player]

    begin
      @player.save(:safe => true)
      flash[:notice] = 'Saved!'
    rescue
      flash[:error] = 'An error occurred! Could not save!'
    end

    @squads = Game.find(@player.game_id).squads
    render :edit
  end

  def new; end
  def create; end
end
