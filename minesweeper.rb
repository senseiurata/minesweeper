class Game

end

class Board
  ROWS = 9
  COLS = 9
  BOMBS = 10

  def initialize
    create
    set_board_neighbors
    place_bombs
    #p "initialization is working"
  end

  def create
    @board = Array.new(9) {Array.new}
    ROWS.times do |row|
      COLS.times do |col|
        @board[row] << Tile.new([row, col])
      end
    end

    @board
  end


  def set_board_neighbors
    ROWS.times do |row|
      COLS.times do |col|
        set_neighbors(@board[row][col])
      end
    end
  end

  def set_neighbors(tile)
    adj_diffs = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    adj_pos = adj_diffs.map { |offset| [tile.pos.first + offset.first, tile.pos.last + offset.last] }
    valid_positions = adj_pos.select do |location|
      (location.first >= 0 ) &&
      (location.first < ROWS) &&
      (location.last >= 0) &&
      (location.last < COLS)
    end

    valid_positions.each do |pos|
      tile.neighbors << @board[pos.first][pos.last]  #CAN we shovel into attr_writer
    end

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
      unless @board[temp_row][temp_col].bombed
        @board[temp_row][temp_col].bombed = true
        placed_bombs += 1
      end
    end
  end

  def get_tile(pos)
#    "#{@board[pos.first][pos.last].neighbors}"
    @board[pos.first][pos.last]
  end

  def update(pos)

  end
end

class Tile
  attr_accessor :neighbors, :bombed
  attr_reader :pos, :revealed

  def initialize(pos)
    @bombed = false
    @flagged = false
    @revealed = false
    @pos = pos
    @neighbors = []
  end

  def status
    if @bombed
      return "*"
    elsif @revealed
      bomb_count = neighbor_bomb_count
      return bomb_count == 0 ? " " : neighbor_bomb_count
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
    unless bombed
      @revealed = true

      bomb_count = neighbor_bomb_count

      if bomb_count == 0
        @neighbors.each do |neighbor|
          neighbor.reveal unless neighbor.revealed
        end
      end
    end

  end

  def neighbor_bomb_count
    bomb_count = 0
    @neighbors.each do |neighbor|
      if neighbor.bombed
        bomb_count += 1
        neighbor.pos
      end
    end

    bomb_count
  end

  def inspect
    "<#{self.class}: #{self.object_id}, @bombed=#{@bombed}, @pos=#{pos} ncount=#{@neighbors.length}>"
  end
end

b = Board.new
b.show

input = gets.chomp.split(" ").map { |str| Integer(str) }

b.get_tile(input).reveal

b.show