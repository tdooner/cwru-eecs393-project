class Admin::GamesController < ApplicationController
  before_filter :set_game, :except => [:index, :new, :create]

  def show
    # Nothing here -- the admin probably wants to edit the game instead.
    redirect_to(edit_admin_game_url(@game))
  end

  def index
    @games = Game.all
  end

  def update
    @game.attributes = params[:game]

    begin
      @game.save(:safe => true)
      flash[:notice] = 'Saved!'
    rescue
      flash[:error] = 'An error occurred! Could not save!'
    end

    render :edit
  end

  def players
    @game = Game.find(params[:id])
    @players = @game.players
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(params[:game])
    @game.save(:safe => true)
    flash[:notice] = 'Game Created!'
    @games = Game.all

    render :index
  end

  def players
    @players = @game.players
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
