require 'debugger'
require './piece.rb'

class InvalidMoveError < ArgumentError
end

class SomeoneThereError < ArgumentError
end

class CantJumpOwnManError < ArgumentError
end

class NoPieceToJumpError < ArgumentError
end

class Board
  attr_accessor :captured_pieces, :grid

  def self.blank_grid
    Array.new(8) { Array.new(8) { nil } }
  end

  def initialize(new_game)
    @grid = new_game ? generate_grid : self.class.blank_grid
    @captured_pieces = []
  end

  def move(move_sequence)
    begin
      start_pos = move_sequence[0][0]
      self[start_pos].perform_moves(move_sequence)
    rescue InvalidMoveError
      false
    end

    true
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, obj)
    x, y = pos
    @grid[x][y] = obj
  end

  def display
    puts "   A  B  C  D  E  F  G  H"

    @grid.each_with_index do |row, x|
      print "#{8 - x} "
      row.each_with_index do |col, y|
        piece = @grid[x][y]
        print piece.nil? ? render_nil(x, y) : piece.render
      end

      puts
    end
  end

  def dup
    new_board = Board.new(false)

    @grid.flatten.compact.map do |piece|
      new_piece = Piece.new(piece.color, piece.position.dup, new_board)
      new_board[piece.position] = new_piece
    end

    new_board
  end

  private
  def render_nil(x, y)
    if (x.even? && y.odd?) || (x.odd? && y.even?)
      "   ".colorize(:background => :black)
    else
      "   ".colorize(:background => :white)
    end
  end

  def generate_grid
    grid = Array.new(8) { Array.new(8) { nil } }

    make_rows(grid, 0, 2, :red)
    make_rows(grid, 3, 4)
    make_rows(grid, 5, 7, :white)

    grid
  end

  def make_rows(grid, fst, lst, color = nil)
    fst.upto(lst) do |row|
      0.upto(7) do |col|
        if ((row.even? && col.odd?) || (row.odd? && col.even?)) && !color.nil?
          grid[row][col] = Piece.new(color, [row, col], self)
        else
          grid[row][col] = nil
        end
      end
    end
  end
end