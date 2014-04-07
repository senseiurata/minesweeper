class Game

end

class Board
  ROWS = 9
  COLS = 9
  BOMBS = 10

  def initialize
    create
  end

  def create
    @board = Array.new(9) {Array.new}
    ROWS.times do |row|
      COLS.times do |col|
        @board[row] << Tile.new([row, col])
      end
    end

    ROWS.times do |row|
      COLS.times do |col|
        @board.set_neighbor(@board[row][col], [row, col])
        @board[row][col].set_neighbors
      end
    end


    @board
  end

  def show
    print "  "
    COLS.times do |col|
      print "#{col} "
    end
    puts

    ROWS.times do |row|
      print "#{row} "
      COLS.times do |col|
        print "#{@board[row][col].status} "
      end
      puts
    end
  end

  def place_bombs
    placed_bombs = 0

    until placed_bombs == BOMBS
      temp_row, temp_col = rand(ROWS), rand(COLS)
      unless @board[temp_row][temp_col].bombed?
        @board[temp_row][temp_col].bombed = true
        placed_bombs += 1
      end
    end
  end

  def update(pos)

  end

end

class Tile
  attr_writer :bombed

  def initialize(pos)
    @bombed = false
    @flagged = false
    @revealed = false
    @pos = pos
  end

  def bombed?
    @bombed
  end

  def status
    if @bombed
      return "*"
    else
      return "-"
    end
    # else
    #
    # if bombed
    #
    # if flagged
  end

  def reveal
    @flagged = false
  end

  def neighbors
    adj_diffs = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    adj_pos = adj_diffs.map { |row, col| [@pos.first + row, @pos.last + col] }
    adj_pos.select! { |row, col| row >= 0 && row < ROWS}
  end

  def neighbor_bomb_count

  end
end

b = Board.new
b.place_bombs

b.show

t = Tile.new([4, 4])
t.neighbors
