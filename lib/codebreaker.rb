require_relative 'codebreaker/version'
require_relative 'codebreaker/game'
require_relative 'codebreaker/interface'

module Codebreaker
  Codebreaker::Game.new

  # for launch in console
  # Codebreaker::Interface.new.launch
end
