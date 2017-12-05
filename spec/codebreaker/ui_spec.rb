require 'spec_helper'

module Codebreaker
  RSpec.describe Interface do

    before do
      interface.instance_variable_set(:@game, game)
    end

    let(:interface) { Codebreaker::Interface.new }
    let(:game) { Codebreaker::Game.new('Max', 10) }

    context '#new_game' do
      it 'exist @game, and owned to Codebreaker::Game' do
        interface.new_game
        game = interface.instance_variable_get(:@game)
        expect(game).to be_a(Game)
      end
    end

    context '#get_player_name' do
      it 'received the message to enter the name' do
      end
    end

    context '#get_attempts_quantity' do
      it 'received the message to enter attempts quantity' do
      end
    end

    context '#get_player_input' do
      it 'received the message to user input' do
      end
    end

    context '#display_game_over' do
      it 'received message "Game over. Sorry, you lose"' do
      end
    end

    context '#display_you_win' do
      it 'received the message you win' do
      end
    end

    context '#play_again' do
      it 'received the message to play again' do
      end

      it 'called #launch if player answer- y' do
      end
    end

    context '#save_result' do
      it 'received the message to save result' do
      end

      it 'called Game::save_result if player answer- y' do
      end
    end

    context '#attempt' do

      it 'received the message to "Invalid data"' do
      end

      it 'received the message to get hint' do
      end
    end
  end
end
