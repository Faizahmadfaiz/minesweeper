require_relative "board.rb"
require "byebug"

class Game
  def initialize(board_size, bomb_size)
    @board = Board.new(board_size, bomb_size)
  end

  def play
    until @board.won? || @board.lost?
      @board.render
      action_type, pos = self.get_move
      self.perform_move(action_type, pos)
    end
    if @board.won?
      puts "You Won!!!"
    else
      puts "You Lose!!!"
      @board.reveal
    end
  end

  def get_move
    type, row, col = gets.chomp.split(",")
    [type, [row.to_i, col.to_i]]
  end

  def perform_move(action_type, pos)
    case action_type

    when "e"
      @board.explore(pos)
    when "f"
      @board.toggle_flag(pos)
    end
  end
end

game = Game.new(9, 9)
game.play