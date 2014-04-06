class Cell
  def initialize(board, alive: true)
    @alive=alive
    @board=board
  end
  def alive=(alive)
    @alive=alive
  end
  def alive?
    return @alive
  end
  def get_neighbors
    @board.neighbors(self)
  end
  def calculate_next_state
    alive_neighbors = get_neighbors.select { |c| c.alive? }.count
    if self.alive?
      return true if alive_neighbors.between?(2,3)
    else
      return true if alive_neighbors.eql? 3
    end
    return false
  end
end
