# frozen_string_literal: true

require_relative 'game'
require 'yaml'

module Codebreaker
  # Describes codebreaker game interface
  class Interface
    PHRASES = 'lib/codebreaker/phrases.yml'.freeze

    attr_reader :phrases

    def new_game
      @game = Codebreaker::Game.new(@player_name, @attempts_quantity)
    end

    def initialize
      @phrases = YAML.load_file(PHRASES)
    end

    def message(val)
      puts val
    end

    def take_player_name
      message(@phrases[:welcome])
      @player_name = gets.chomp
      take_player_name if @player_name.empty?
    end

    def take_attempts_quantity
      message(@phrases[:attempts_quantity])
      @attempts_quantity = gets.to_i
      take_attempts_quantity if @attempts_quantity.zero?
    end

    def take_player_input
      message(@phrases[:player_input])
      @user_input = gets.chomp
    end

    def display_game_over
      message(@phrases[:lose]) if @game.lose?
    end

    def display_you_win
      message(@phrases[:win]) if @game.victory?
    end

    def play_again
      message(@phrases[:again])
      answer = gets.chomp
      launch if answer == 'y'
    end

    def save_result
      message(@phrases[:result])
      answer = gets.chomp
      @game.save_result(@player_name, @game.count, @game.player_arr) if answer == 'y'
    end

    def attempt
      loop do
        take_player_input
        result = @user_input == 'hint' ? @game.check_hint : @game.guess(@user_input)
        result ||= 'Invalid data'
        p result
        break if display_you_win
        break if @game.attempts_quantity.zero?
        break if @user_input == 'exit'
      end
      display_game_over
      save_result
      play_again
    end

    def launch
      take_player_name
      take_attempts_quantity
      new_game
      attempt
    end
  end
end
