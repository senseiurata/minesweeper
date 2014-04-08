class Game
  def initialize
    puts "Welcome to minesweeper!"
  end

  def run
    board = Board.new

    until board.over == :lose || board.over == :win
      board.show
      print "Pick a spot: "
      selection = gets.chomp.split(" ").map { |str| Integer(str) }
      print "Type 'd' to dig, Type 'f' to flag: "
      action = gets.chomp

      if action == "d"
        board.get_tile(selection).reveal
      else
        board.get_tile(selection).flagged = !board.get_tile(selection).flagged
      end
      game_over = board.over
    end

    puts "#{game_over}"
  end

end

class Board
  ROWS = 9
  COLS = 9
  BOMBS = 4

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
      tile.neighbors << @board[pos.first][pos.last]
    end

  end

  def over
    ROWS.times do |row|
      COLS.times do |col|
        p tile = @board[row][col]
        "tile: #{tile.bombed} #{tile.revealed}"
        return :lose if (tile.bombed && tile.revealed)
      end
    end

    return nil if !tile.bombed && !tile.revealed

    :win
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
    @board[pos.first][pos.last]
  end

  def update(pos)

  end
end

class Tile
  attr_accessor :neighbors, :bombed, :flagged
  attr_reader :pos, :revealed

  def initialize(pos)
    @bombed = false
    @flagged = false
    @revealed = false
    @pos = pos
    @neighbors = []
  end

  def status
    if @flagged
      return "F"
    elsif @revealed
      bomb_count = neighbor_bomb_count
      return bomb_count == 0 ? " " : neighbor_bomb_count
    elsif @bombed
      return "*"
    else
      return "-"
    end
  end

  def reveal
    unless bombed
      @revealed = true

      bomb_count = neighbor_bomb_count

      if bomb_count == 0
        @neighbors.each do |neighbor|
          neighbor.reveal unless (neighbor.revealed || neighbor.flagged)
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

if __FILE__ == $PROGRAM_NAME
  Game.new.run
end