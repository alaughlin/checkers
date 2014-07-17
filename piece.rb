class InvalidMoveError < ArgumentError
end

class SomeoneThereError < ArgumentError
end

class CantJumpOwnManError < ArgumentError
end

class NoPieceToJumpError < ArgumentError
end

class Piece
  attr_reader :color
  attr_accessor :position, :board

  def initialize(color, position, board, kinged = false)
    @color, @position, @board, @kinged = color, position, board, kinged
  end

  def move(target)
    slide_offsets = slide_diffs(@color)
    jump_offsets = jump_diffs(@color)
    current_offset = [target[0] - @position[0], target[1] - @position[1]]

    valid_moves =

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
      @board[@position] = nil
      @board[@position] = self

      @position = target
    else
      raise SomeoneThereError
    end
  end

  def perform_jump(target)
    if @board[target].nil?
      jumped_piece = get_jumped_piece(target)

      if @board[jumped_piece].nil?
        raise NoPieceToJumpError
      elsif @board[jumped_piece].color == @color
        raise CantJumpOwnManError
      else
        # set position of piece that was moved...
        @board[@position] = nil
        @position = target
        @board[@position] = self

        # remove jumped piece
        @board[jumped_piece].position = nil
        @board[jumped_piece] = nil
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