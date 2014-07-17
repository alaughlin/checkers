require 'debugger'

class Piece
  attr_reader :color
  attr_accessor :position, :board

  def initialize(color, position, board = nil, kinged = false)
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
    slide_offsets = slide_diffs(color)
    jump_offsets = jump_diffs(color)
    target_offset = [target[0] - position[0], target[1] - position[1]]

    jumps_available = get_your_pieces.select do |piece|
      are_jumps_available?(piece, jump_offsets)
    end

    if jump_offsets.include?(target_offset)
      perform_jump(target)
    elsif slide_offsets.include?(target_offset)
      if jumps_available.length > 0
        return false
      else
        perform_slide(target)
      end
    else
      return false
    end

    true
  end

  def valid_move_seq?(move_sequence)
    new_board = @board.dup

    begin
      new_self = new_board[@position]
      new_self.perform_moves!(move_sequence)
    rescue InvalidMoveError
      false
    end

    true
  end

  def perform_moves(move_sequence)
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    end
  end

  def perform_moves!(move_sequence)
    move_sequence.each do |step|
      target = step[1]
      raise InvalidMoveError unless move(target)
    end
  end

  def are_jumps_available?(piece, offsets)
    offsets.any? do |offset|
      target = [offset[0] + piece.position[0], offset[1] + piece.position[1]]
      jumped_piece = get_jumped_piece(target)

      can_i_jump?(target, jumped_piece)
    end
  end

  def can_i_jump?(target, jumped_piece)
    if (target[0] >= 0 && target[0] < 8) && (target[1] >= 0 && target[1] < 8)
      return false unless board[target].nil?
      return false if board[jumped_piece].nil?
      return false if board[jumped_piece].color == @color

      true
    else
      return false
    end
  end

  def perform_jump(target)
    jumped_piece = get_jumped_piece(target)
    if can_i_jump?(target, jumped_piece, board)
      # set position of piece that was moved...
      board[@position] = nil
      board[target] = self

      @position = target

      # remove jumped piece
      board[jumped_piece] = nil
    end
  end

  def perform_slide(target)
    if board[target].nil?
      board[@position] = nil
      board[target] = self
      @position = target
    end
  end

  def slide_diffs(color)
    color == :red ? [[1, -1], [1, 1]] : [[-1, -1], [-1, 1]]
  end

  def jump_diffs(color)
    color == :red ? [[2, -2], [2, 2]] : [[-2, -2], [-2, 2]]
  end

  def get_jumped_piece(target)
    if color == :red
      if position[1] < target[1]
        [target[0] - 1, target[1] - 1]
      else
        [target[0] - 1, target[1] + 1]
      end
    else
      if position[1] < target[1]
        [target[0] + 1, target[1] - 1]
      else
        [target[0] + 1, target[1] + 1]
      end
    end
  end

  def maybe_promote
  end

  def render
    if color == :white
      " ● ".colorize(:color => :light_white).colorize(:background => :black)
    else
      " ● ".colorize(:color => :red).colorize(:background => :black)
    end
  end
end