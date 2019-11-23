class Tile
  attr_accessor :value, :revealed, :flagged
  def initialize(value)
    @value = value
    @revealed = false
    @flagged = false
  end

  def revealed?
    @revealed
  end

  def flagged?
    @flagged
  end

  def bombed?
    if @value == "B"
      return true
    else
      return false
    end
  end
end