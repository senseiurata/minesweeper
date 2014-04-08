require 'yaml'

class Game
  def initialize
    puts "Welcome to minesweeper!"
  end

  def run
    board = Board.new

    until board.over == :lose || board.over == :win
      board.show
      print "Type 'd' to dig, 'f' to flag, 's' to save, 'l' to load: "
      action = gets.chomp

      if action == "d" || action == "f"
        print "Pick a spot: "
        selection = gets.chomp.split(" ").map { |str| Integer(str) }
        if action == "d"
          board.get_tile(selection).reveal
        elsif action == "f"
          board.get_tile(selection).flagged = !board.get_tile(selection).flagged
        end
      elsif action == "s"
        save_contents = board.to_yaml
        f = File.open("save.txt", "w")
        f.puts save_contents
        f.close
      elsif action == "l"
        board_contents = File.read("save.txt")
        board = YAML::load(board_contents)
      end
      game_over = board.over
    end

    board.reveal_mines
    board.show

    if game_over == :lose
      puts "You lose!"
    else
      puts "You win!"
    end
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

  def reveal_mines
    ROWS.times do |row|
      COLS.times do |col|
        @board[row][col].revealed = true if @board[row][col].bombed
      end
    end
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
    ongoing = false
    ROWS.times do |row|
      COLS.times do |col|
        tile = @board[row][col]
        #p "tile: #{tile.bombed} #{tile.revealed}"
        return :lose if (tile.bombed && tile.revealed)
        ongoing = true if !tile.bombed && !tile.revealed
      end
    end

    if ongoing
      nil
    else
      :win
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
    @board[pos.first][pos.last]
  end
end

class Tile
  attr_accessor :neighbors, :bombed, :flagged, :revealed
  attr_reader :pos

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
    elsif @bombed && @revealed
      return "*"
    elsif @revealed
      bomb_count = neighbor_bomb_count
      return bomb_count == 0 ? " " : neighbor_bomb_count
    else
      return "-"
    end
  end

  def reveal
    @revealed = true
    unless bombed
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