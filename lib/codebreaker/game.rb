# frozen_string_literal: true

require_relative 'version'

module Codebreaker
  # Describes codebreaker game logic
  class Game
    SECRET_CODE_SIZE = 4

    attr_reader :count, :hint_quantity, :attempts_quantity, :secret_arr
    attr_accessor :player_arr

    def initialize(name = 'Player', attempts = 10)
      @player_name = name
      @attempts_quantity = attempts
      @secret_arr = []
      @player_arr = []
      @hint_quantity = 1
      @count = 0
      generate_code!
    end

    def guess(str)
      @attempts_quantity -= 1
      @count += 1
      select_only_digits(str)
      str_to_arr(@player_str)
      result = valid_data? ? compare_of_value(@player_arr) : false
      result
    end

    def select_only_digits(str)
      @player_str = /[1-6]{4}/.match(str).to_s
    end

    def str_to_arr(str)
      @player_arr = str.split('').map(&:to_i)
    end

    def compare_of_value(player_arr)
      secret_arr = Array.new(@secret_arr)
      player_arr = Array.new(player_arr)
      result_str = ''
      player_arr.each_index do |i|
        next unless player_arr[i] == secret_arr[i]
        result_str += '+'
        secret_arr[i] = 0
        player_arr[i] = nil
      end
      player_arr.each_index do |i|
        next unless secret_arr.include?(player_arr[i])
        result_str += '-'
        index = secret_arr.find_index(player_arr[i])
        secret_arr[index] = 0
      end
      result_str
    end

    def check_hint
      if @hint_quantity == 1
        @attempts_quantity -= 1
        @hint_quantity -= 1
        take_hint
      elsif @hint_quantity.zero?
        false
      end
    end

    def victory?
      player_arr == secret_arr
    end

    def lose?
      attempts_quantity <= 0
    end

    def valid_data?
      player_arr.is_a?(Array) && player_arr.size == secret_arr.size
    end

    def save_result(name, count, player_arr)
      File.open("#{name}_file.txt", 'w') do |file|
        file.write("player name: #{name}, attempts quantity: #{count}, winning combination: #{player_arr}")
      end
    end

    private

    def take_hint
      hint = '*' * SECRET_CODE_SIZE
      random = rand(SECRET_CODE_SIZE)
      hint[random] = secret_arr[random].to_s
      hint
    end

    def generate_code!
      SECRET_CODE_SIZE.times { |_i| @secret_arr << rand(1..6) }
    end
  end
end
