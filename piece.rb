class InvalidMoveError < ArgumentError
end

class SomeoneThereError < ArgumentError
end

class CantJumpOwnManError < ArgumentError
end

class Piece
  attr_reader :color

  def initialize(color, position, grid, kinged = false)
    @color, @position, @grid, @kinged = color, position, grid, kinged
  end

  def move(target)
    slide_offsets = slide_diffs(@color)
    jump_offsets = jump_diffs(@color)
    current_offset = [target[0] - @position[0], target[1] - @position[1]]

    if jump_offsets.include?(current_offset)
      perform_jump(target)
    elsif slide_offsets.include?(current_offset)
      perform_slide(target)
    else
      raise InvalidMoveError
    end

    nil
  end

  def perform_slide(target)
    if @grid[target].nil?
      @grid[@position] = nil
      @position = target
      @grid[@position] = self
    else
      raise SomeoneThereError
    end
  end

  def perform_jump(target)
    if @grid[target].nil?
      if @color == :red
        jumped_piece = get_jumped_piece(target)
        if @grid[jumped_piece].color == @color
          raise CantJumpOwnManError
        else
          @grid[@position] = nil
          @position = target
          @grid[@position] = self
        end
      elsif @color == :white
        jumped_piece = get_jumped_piece(target)
        if @grid[jumped_piece].color == @color
          raise CantJumpOwnManError
        else
          @grid[@position] = nil
          @position = target
          @grid[@position] = self
        end
      end
    else
      raise SomeoneThereError
    end
  end

  def slide_diffs(color)
    color == :red ? [[1, -1], [1, 1]] : [[-1, -1], [-1, 1]]
  end

  def jump_diffs(color)
    color == :red ? [[2, -2], [2, 2]] : [[-2, -2], [-2, 2]]
  end

  def get_jumped_piece(target)
    if @color == :red
      [target[0] - 1, target[1] - 1]
    else
      [target[0] + 1, target[1] + 1]
    end
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