class GamesController < ActionController::Base
  layout 'application'

  def show
    @game = Game.find(params[:id])
  end

  def register
    @game = Game.find(params[:id])
    @user = current_user

    # TODO: Make this logic not here:
    @player = Player.where(:game_id => @game.id, :user_id => @user.id).first
    if @player
      flash[:notice] = 'You are already registered!'
    else
      Player.create(:game_id => @game.id, :user_id => @user.id)
      flash[:notice] = 'You have been registered!'
    end
    redirect_to game_url(@game)
  end
end