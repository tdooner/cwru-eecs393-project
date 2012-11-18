class GamesController < ActionController::Base
  layout 'application'
  before_filter :set_game

  def show; end

  def register
    if current_user.registered?(@game)
      flash[:notice] = 'You are already registered!'
    else
      current_user.register_for_game(@game)
      flash[:notice] = 'You have been registered!'
    end

    redirect_to game_url(@game)
  end

  def unregister
    if current_user.registered?(@game)
      current_user.unregister_for_game(@game)
      flash[:notice] = 'You have been unregistered!'
    else
      flash[:notice] = 'You are not registered!'
    end

    redirect_to game_url(@game)
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
