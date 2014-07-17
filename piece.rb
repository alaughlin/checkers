class InvalidMoveError < ArgumentError
end

class Piece
  def initialize(color, position, grid, kinged = false)
    @color, @position, @grid, @kinged = color, position, grid, kinged
  end

  def move(target)
    slide_offsets = slide_diffs(@color)
    jump_offsets = jump_diffs(@color)
    current_offset = [target[0] - @position[0], target[1] - @position[1]]

    if jump_offsets.include?(current_offset)
      perform_jump(target)
    else slide_offsets.include?(current_offset)
      perform_slide(target)
    end

    nil
  end

  def perform_slide(target)
    if @grid[target].nil?
      @grid[@position] = nil
      @position = target
      @grid[@position] = self
    else
      raise InvalidMoveError
    end
  end

  def perform_jump(target)
    if @grid[target].nil?
      @grid[@position] = nil
      @position = target
      @grid[@position] = self
    else
      raise InvalidMoveError
    end
  end

  def slide_diffs(color)
    color == :red ? [[1, -1], [1, 1]] : [[-1, -1], [-1, 1]]
  end

  def jump_diffs(color)
    color == :red ? [[2, -2], [2, 2]] : [[-2, -2], [-2, 2]]
  end

  def maybe_promote

  end

  def render
    if @color == :white
      " ● ".colorize(:color => :light_white).colorize(:background => :black)
    else
      " ● ".colorize(:color => :red).colorize(:background => :black)
    end
  end
end