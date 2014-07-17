#!/usr/bin/env ruby

require 'colorize'
require './board.rb'

class Game
  ROWS = {
    "8" => 0,
    "7" => 1,
    "6" => 2,
    "5" => 3,
    "4" => 4,
    "3" => 5,
    "2" => 6,
    "1" => 7
  }

  COLS = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7
  }

  def initialize
    @board = Board.new(true)
  end

  def play
    until won?
      @board.display
      print "Enter your move (b6,a5): "
      begin
        input = gets.chomp

        input = input.split(",")

        src = [ROWS[input[0][1]], COLS[input[0][0]]]
        target = [ROWS[input[1][1]], COLS[input[1][0]]]

        @board.move([ [[2,1], [3,0]], [[3,0], [4,1]] ])
      rescue InvalidMoveError
        print "Invalid move! Try again: "
        retry
      end
    end
  end

  def won?
    false
  end
end

g = Game.new
g.play