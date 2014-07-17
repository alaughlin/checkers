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

  def get_your_pieces
    pieces = []
    @board.grid.each do |row|
      row.each do |piece|
        pieces << piece if !piece.nil? && piece.color == @color
      end
    end

    pieces
  end

  def move(target)
    slide_offsets = slide_diffs(@color)
    jump_offsets = jump_diffs(@color)
    current_offset = [target[0] - @position[0], target[1] - @position[1]]

    jumps_available = get_your_pieces.select do |piece|
      are_jumps_available?(piece, jump_offsets)
    end

    if jump_offsets.include?(current_offset)
      perform_jump(target, @board)
    elsif slide_offsets.include?(current_offset)
      if jumps_available.length > 0
        raise InvalidMoveError
      else
        perform_slide(target, @board)
      end
    else
      raise InvalidMoveError
    end

    nil
  end

  def are_jumps_available?(piece, offsets)
    offsets.any? do |offset|
      new_board = @board.dup
      target = [offset[0] + piece.position[0], offset[1] + piece.position[1]]

      can_i_jump?(target, new_board)
    end
  end

  def can_i_jump?(target, board)
    if (target[0] >= 0 && target[0] < 8) && (target[1] >= 0 && target[1] < 8)
      return false unless board[target].nil?

      jumped_piece = get_jumped_piece(target)
      return false if board[jumped_piece].nil?
      return false if board[jumped_piece].color == @color

      true
    else
      return false
    end
  end

  def perform_jump(target, board)
    if can_i_jump?(target, board)
      # set position of piece that was moved...
      board[@position] = nil
      board[target] = self

      @position = target

      # remove jumped piece
      jumped_piece = get_jumped_piece(target)
      board[jumped_piece] = nil

      true
    else
      false
    end
  end

  def perform_slide(target, board)
    if board[target].nil?
      board[@position] = nil
      board[target] = self
      @position = target

      true
    else
      false
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