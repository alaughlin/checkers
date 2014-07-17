require './piece.rb'

class Board
  def initialize(grid = nil)
    @grid = grid.nil? ? generate_grid : grid
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, obj)
    x, y = pos
    @grid[x][y] = obj
  end

  private
  def generate_grid
    grid = Array.new(8) { Array.new { nil } }

    make_rows(grid, fst, lst, :red)
    make_rows(grid, fst, lst)
    make_rows(grid, fst, lst, :white)

    grid
  end

  def make_rows(grid, fst, lst, color = nil)
    fst.upto(lst) do |row|
      0.upto(y) do |col|
        if ((row.even? && col.odd?) || (row.odd? && col.even?)) && !color.nil?
          grid[row, col] = Piece.new(color, [row, col], grid)
        else
          grid[row, col] = nil
      end
    end
  end
end