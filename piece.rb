class Piece
  def initialize(color, position, grid, kinged = false)
    @color, @position, @grid, @kinged = color, position, grid, kinged
  end

  def render
    if @color == :white
      " ● ".colorize(:color => :light_white)
    else
      " ● ".colorize(:color => :red)
    end
  end
end