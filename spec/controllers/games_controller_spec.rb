require 'spec_helper'

describe GamesController do
  before do
    @user = FactoryGirl.create(:user)
    @game = FactoryGirl.create(:game)
    @player = FactoryGirl.create(:player, :game => @game, :user => @user)
    controller.stub(:players => [@player])
    sign_in @user
  end

  describe '#show' do
    render_views

    before do
      get :show, :id => @game.id
    end

    it "renders the name of the current game" do
      response.body.should include(@game.name)
    end

    it "renders the player's name" do
      response.body.should include(@player.user.name)
    end

    it "renders the player's points" do
      response.body.should include(@player.points.to_s)
    end
  end

  describe '#register' do
    context 'when a user is logged out' do
      before do
        sign_out @user
        get :register, :id => @game.id
      end

      it 'should redirect to the homepage' do
        response.should redirect_to(root_url)
      end
    end

    context 'when a user is logged in' do
      before do
        sign_in @user
      end

      it 'ensures the user has completed steps prior' do
        controller.should_receive(:completed?).exactly(2).times.
          and_return(true, false)
        get :register, :id => @game.id, :step => :squad
      end

      it 'redirects the user to a prior step if they have not completed it' do
        Player.any_instance.stub(:signed_waiver => false)
        get :register, :id => @game.id, :step => :confirm
        response.should redirect_to(register_game_url(@game, :waiver))
      end
    end
  end

  describe '#unregister' do
    context 'when the user is indeed registered for that game' do
      it "removes that user's player object" do
        expect { get :unregister, :id => @game.id }.to change { Player.count }.
          by(-1)
        @user.registered?(@game).should be_false
      end
    end

    context 'when the user is not registered' do
      before do
        @user.unregister_for_game(@game)
      end

      it 'redirects you to the game page' do
        get :unregister, :id => @game.id
        response.should redirect_to(game_url(@game))
      end
    end
  end

  describe 'permissions' do
    context 'for site admins' do
      before do
        @user.set(:site_admin => true)
        sign_in @user
      end

      it 'allow them to manage games' do
        controller.can?(:manage, @game).should be_true
      end
    end

    context 'non-site admins' do
      before do
        @user.set(:site_admin => false)
        sign_in @user
      end

      it 'prohibit them from managing games' do
        controller.can?(:manage, @game).should be_false
      end
    end
  end
end
