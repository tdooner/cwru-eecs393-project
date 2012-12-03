class GamesController < ApplicationController
  layout 'application'
  before_filter :set_game
  before_filter :set_player
  before_filter :authenticate_user!, :only => [:register, :unregister]

  def show
    @players = @game.players.sort(:points.desc)
  end

  def register
    # Assume these two variables are retrieved with an engine call...
    # ... or better yet the engine returns a list of objects
    @steps = [:begin, :waiver, :squad, :off_campus, :confirm, :done]
    @step_titles = ['Register for Game', 'Sign Waiver', 'Choose Squad', 'Off Campus?', 'Confirmation', 'Done!']

    @step = :begin if !params[:step].present?
    @step = @step || (params[:step].to_sym if @steps.include?(params[:step].to_sym))
    @step ||= :begin

    @next_step = @steps[@steps.find_index { |i| i == @step } + 1]
    @prior_step = @steps[@steps.find_index { |i| i == @step } - 1]

    if !process_steps
      flash.keep
      return redirect_to register_game_url(@game, @prior_step)
    end

    @steps.each do |s|
      break if s == @step

      if !completed?(s)
        flash[:alert] = 'You cannot complete that step of registration yet!'
        return redirect_to register_game_url(@game, s)
      end
    end

    load_step(@step)

    if (@step == :done && params[:confirmed] == 'true')
      @player.registered = true
      @player.card_code ||= Player.generate_card_code
      @player.save(safe: true)
    end
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

    if !@game.present?
      flash[:error] = 'Game not found!'
      return redirect_to(root_url)
    end
  end

  def set_player
    if current_user && !(@player = Player.where(user_id: current_user.id, game_id: @game.id).first)
      @player = Player.create(registered: false, user_id: current_user.id, game_id: @game.id)
    end
  end

  ####
  # Registration helper functions:
  ####
  # Eventually move this to the engine:
  def completed?(step)
    case step
    when :begin
      true
    when :waiver
      @player.signed_waiver?
    when :squad
      @player.joined_squad?
    when :off_campus
      !@player.off_campus.nil?
    when :confirm
      true
    when :done
      @player.registered == true
    end
  end

  def process_steps
    if params[:waiver]
      @player.waiver = Waiver.new(params[:waiver])

      if @player.waiver.valid? &&
        @player.save(safe: true)
      else
        flash[:alert] = 'Error: ' + @player.waiver.errors.full_messages.first
        return false
      end
    end

    if params[:squad]
      if params[:squad][:name]
        @player.squad = Squad.find_by_name_and_game_id(params[:squad][:name], @game.id)
      else
        if params[:squad][:new_name]
          @player.squad = Squad.find_or_create_by_name_and_game_id(params[:squad][:new_name], @game.id)
          @player.squad.game = @game
        end
      end

      @player.save(safe: true)
    end

    if params[:off_campus]
      @player.off_campus = (params[:off_campus] == 'true') ? true : false
      @player.save(safe: true)
    end

    true
  end

  def load_step(step)
    case step
    when :waiver
      @waiver = @player.waiver || Waiver.new
    when :squad
      @squad = @player.squad || Squad.new
    end
  end
end
