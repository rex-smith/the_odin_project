class Player
  def initialize(name, marker)
    @marker = marker
    @name = name
  end

  # Make sure we can read the marker and name
  attr_reader :marker
  attr_reader :name

  def choose(board, cell, marker)
    board.fill_cell(cell, marker)
  end
end

class Board
  def initialize()
    @board_array = Array.new(3) {Array.new(3," ")}  
  end
  
  def create_players()
    @players = []
    player_1 = Player.new("Player 1", "X")
    @players.push(player_1)
    player_2 = Player.new("Player 2", "O")
    @players.push(player_2)
    @active_player = @players[0]
  end
  attr_accessor :active_player

  def switch_active_player()
    # Switch active player
    if @active_player == @players[0]
      @active_player = @players[1]
    else
      @active_player = @players[0]
    end
  end


  def show_board()
    puts "  1 | 2 | 3"
    puts "-----------"
    puts "1 #{@board_array[0][0]} | #{@board_array[0][1]} | #{@board_array[0][2]}"
    puts "-----------"
    puts "2 #{@board_array[1][0]} | #{@board_array[1][1]} | #{@board_array[1][2]}"
    puts "-----------"
    puts "3 #{@board_array[2][0]} | #{@board_array[2][1]} | #{@board_array[2][2]}"
  end

  def get_player_choice()
    puts "#{@active_player.name} please choose a row:"
    row = gets.chomp.to_i - 1
    puts "#{@active_player.name} please choose a column:"
    column = gets.chomp.to_i - 1
    chosen_cell = [row,column]
    return chosen_cell
  end

  def authenticate_choice(cell)
    if cell[0].between?(0,2) && cell[1].between?(0,2)
      if @board_array[cell[0]][cell[1]] == " "
        return true
      else
        puts "This cell is already taken. You will need to choose again."
        return false
      end  
    else
      puts "This isn't an option in the grid. Please choose again."
      return false
    end
  end

  def fill_cell(cell, marker)
    @board_array[cell[0]][cell[1]] = marker
  end

  # Checking rows
  def check_row()
    for i in @board_array
      if i[0] == i[1] && i[1] == i[2] && i[0] != " "
        return true
      end
    end
    return false
  end

  # Checking columns
  def check_column()
    for i in 0..2
      if @board_array[0][i] == @board_array[1][i] && @board_array[1][i] == @board_array[2][i] && @board_array[0][i] != " "
        return true
      end
    end
    return false
  end

  # Checking diagonals
  def check_diagonals()
    if @board_array[0][0] == @board_array[1][1] && @board_array[1][1] == @board_array[2][2] && @board_array[1][1] != " "
      return true
    elsif @board_array[0][2] == @board_array[1][1] && @board_array[1][1] == @board_array[2][0] && @board_array[1][1] != " "
      return true
    else
      return false
    end
  end


  # Check if there is a winner
  def winner?()
    # p check_row
    # p check_column
    # p check_diagonals
    check_row() | check_column() | check_diagonals()
  end

end

def play_game()
  tic_board = Board.new()
  tic_board.create_players()
  tic_board.show_board()

  while tic_board.winner? == false
    chosen_cell = tic_board.get_player_choice()
    while tic_board.authenticate_choice(chosen_cell) == false
      chosen_cell = tic_board.get_player_choice()
    end
    tic_board.active_player.choose(tic_board, chosen_cell, tic_board.active_player.marker)

    # Check if winner after selection, then end game if so
    if tic_board.winner?
      puts "#{tic_board.active_player.name} wins!"
      tic_board.show_board()
      return
    end
    tic_board.show_board()
    tic_board.switch_active_player()
  end
end

play_game()