require 'spec_helper'

describe Player do
  let(:user) { FactoryGirl.create(:user) }
  let(:player) { FactoryGirl.create(:player) }

  describe 'signed_waiver?' do
    context 'when the user has not signed a waiver' do
      it 'returns false' do
        player.signed_waiver?.should be_false
      end
    end

    context 'when the user *has* signed a waiver' do
      before do
        player.waiver = FactoryGirl.create(:waiver)
      end

      it 'returns true' do
        player.signed_waiver?.should be_true
      end
    end
  end

  describe 'joined_squad?' do
    context 'when the user has not joined a squad' do
      it 'returns false' do
        player.joined_squad?.should be_false
      end
    end

    context 'when the user has joined a squad' do
      before do
        player.squad = FactoryGirl.create(:squad)
      end

      it 'returns true' do
        player.joined_squad?.should be_true
      end
    end
  end
end

