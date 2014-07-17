require 'colorize'
require './piece.rb'

class Board
  attr_accessor :captured_pieces, :grid

  def initialize(grid = nil)
    @grid = grid.nil? ? generate_grid : grid
    @captured_pieces = []
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
    @grid.each_with_index do |row, x|
      row.each_with_index do |col, y|
        piece = @grid[x][y]
        print piece.nil? ? render_nil(x, y) : piece.render
      end

      puts
    end

    nil
  end

  def dup
    new_grid = @grid.map do |row|
      row.map do |piece|
        piece.nil? ? nil : piece.dup
      end
    end

    Board.new(new_grid)
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