class Piece
  def initialize(color, position, grid, kinged = false)
    puts "making piece!"
    @color, @position, @grid, @kinged = color, position, grid, kinged
  end

  def render
    if @color == :white
      " ● ".colorize(:color => :light_white).colorize(:background => :black)
    else
      " ● ".colorize(:color => :red).colorize(:background => :black)
    end
  end
end