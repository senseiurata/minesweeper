class Game

end

class Board
  ROWS = 9
  COLS = 9

  def initialize

    create
  end

  def create
    @board = Array.new(9) {Array.new}
    BOARD_ROWS.times do |row|
      BOARD_COLS.times do |col|
        @board[row] << Tile.new([row, col])
      end
    end
    @board
  end

  def show

  end

  def place_bombs(num_mines)

  end

  def update_board(pos)

  end

end

class Tile
  def initialize(pos)
    @bombed = false
    @flagged = false
    @revealed = false
    @pos = pos
  end

  def reveal

  end

  def neighbors

  end

  def neighbor_bomb_count

  end
end