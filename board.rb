require_relative "tile.rb"
require "byebug"

class Board
  DELTAS = [
    [-1, -1],
    [-1,  0],
    [-1,  1],
    [ 0, -1],
    [ 0,  1],
    [ 1, -1],
    [ 1,  0],
    [ 1,  1]
  ].freeze

  def initialize(board_size, bomb_size)
    @size = board_size
    @grid = Array.new(board_size) do |row|
      Array.new(board_size) do |col|
        Tile.new("_")
      end
    end
    self.place_bombs(bomb_size)
  end

  def won?
    @grid.flatten.all? do |tile|
      (!tile.bombed? && tile.revealed?) || (tile.bombed? && !tile.revealed?)
    end
  end

  def lost?
    @grid.flatten.any? do |tile|
      tile.bombed? && tile.revealed?
    end
  end

  def place_bombs(n)
    count = 0
    while count < n do
      row = rand(@size)
      col = rand(@size)
      if @grid[row][col].value != "B"
        @grid[row][col].value = "B"
        count += 1
      end
    end
  end

  def render
    (0...@size).each do |row|
      (0...@size).each do |col|
        if @grid[row][col].revealed?
          print("#{@grid[row][col].value}")
        elsif @grid[row][col].flagged?
          print("F")
        else
          print("*")
        end
      end
      print("\n")
    end
  end

  def reveal
    (0...@size).each do |row|
      (0...@size).each do |col|
        print("#{@grid[row][col].value}")
      end
      print("\n")
    end
  end

  def explore(pos)
    if @grid[pos[0]][pos[1]].value == "B"
      @grid[pos[0]][pos[1]].revealed = true
      return
    end

    if @grid[pos[0]][pos[1]].flagged?
      return
    end

    queue = Array.new(1, pos)
    until queue.empty?
      p = queue.shift
      neighbours = self.neighbours(p)
      neighbours = neighbours.select { |neighbour| !@grid[neighbour[0]][neighbour[1]].revealed? && !queue.include?(neighbour)}
      bomb_count = 0
      neighbours.each do |neighbour_pos|
        neighbour_row, neighbour_col = neighbour_pos
        if @grid[neighbour_row][neighbour_col].value == "B"
          bomb_count += 1
        end
      end

      if bomb_count > 0
        @grid[p[0]][p[1]].value = bomb_count
        @grid[p[0]][p[1]].revealed = true
      else
        @grid[p[0]][p[1]].revealed = true
        # @grid[p[0]][p[1]].value = "*"
        queue += neighbours
      end
    end
  end

  def toggle_flag(pos)
    row, col = pos
    @grid[row][col].flagged = !@grid[row][col].flagged
  end

  def neighbours(pos)
    row, col = pos
    DELTAS.map do |dx, dy|
      [row+dx, col+dy]
    end.select do |row, col|
      [row, col].all? { |ele| ele.between?(0, @size-1)}
    end
  end
end

# b = Board.new(9, 5)
# b.render