class Admin::GamesController < ApplicationController
    def show
        @game = Game.find(params[:id])
        redirect_to(edit_admin_game_url(@game))
    end
    def index
      @games = Game.all
    end
    def edit
      @game = Game.find(params[:id])
    end
    def update
      @game = Game.find(params[:id])
      #@game.name = params[:name]
      @game.attributes = params[:game]
      @game.save(:safe => true)
      flash[:notice] = 'Saved!'
      render :edit
    end
    def new; end
    def create; end
    def players
      @game = Game.find(params[:id])
      @players = @game.players
    end
end