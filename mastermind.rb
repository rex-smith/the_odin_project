class Player
  def initialize(role)
    @white_dots = 0
    @black_dots = 0
    @wins = 0
    @losses = 0
    @role = role
    @guess_array = []
  end

  attr_accessor :white_dots
  attr_accessor :black_dots
  attr_accessor :guess_array

  def win()
    puts "#{@role} won the game!"
    @wins +=1
    puts "#{@role} has won #{@wins} time(s) and lost #{@losses} time(s)!"
  end

  def loss()
    puts "#{@role} lost the game!"
    @losses +=1
    puts "#{@role} has won #{@wins} time(s) and lost #{@losses} time(s)!"
  end

end

class Human < Player

  def select_code()
    puts "Codemaker, please enter your four colors for your code."
    @code = gets.chomp.split(' ')
    return @code
  end

  def guess_code()
    puts "Codebreaker, please guess the code."
    @guess = gets.chomp.split(' ')
    @black_dots = 0
    @white_dots = 0
    @guess_array.push(@guess)
    return @guess
  end

end

class Computer < Player

  def select_code()
    @color_array = ['red', 'yellow', 'blue', 'purple', 'green', 'orange']
    @color1 = @color_array[(rand()*6).floor]
    @color2 = @color_array[(rand()*6).floor]
    @color3 = @color_array[(rand()*6).floor]
    @color4 = @color_array[(rand()*6).floor]
    @code = [@color1, @color2, @color3, @color4]
    return @code
  end
end

class Game
  def initialize()
    @results = []
    @rounds = 0
  end
  def game_start()
    @game_won = false
  end
  def game_end()
    @game_won = true
    @codebreaker.guess_array = []
  end

  def compare_guess(guess, code)
    @remaining_code = []
    @remaining_guess = []
    @codebreaker.black_dots = 0
    @codebreaker.white_dots = 0

    # Black Dots
    guess.each_with_index do |value, index|
      if value == @code[index]
        @codebreaker.black_dots += 1
      else
        @remaining_code.push(@code[index])
        @remaining_guess.push(value)
      end
    end

    # White dots
    @remaining_guess.each do |i|
      @remaining_code.each do |j|
        if i == j
          @codebreaker.white_dots += 1
        end
      end
    end
    @results.push([@codebreaker.black_dots, @codebreaker.white_dots])

    # Check if they won
    if @codebreaker.black_dots == 4
      @codebreaker.win()
      @codemaker.loss()
      game_end()
      return
    end
    return
  end

  def display_guesses(guess_array, results)
    guess_array.each_with_index do |value, index|
      puts "#{value[0]} - #{value[1]} - #{value[2]} - #{value[3]} | B: #{results[index][0]} | W: #{results[index][1]}"
    end
    puts ""
  end
  def create_players()
    # CODE MAKER SELECTION
    @codemaker_selection = ''
    puts "Is the codemaker a human or computer? (Enter 'human' or 'computer')"
    @codemaker_selection = gets.chomp.to_s.downcase
    until (@codemaker_selection == 'human' || @codemaker_selection == 'computer')
      puts "You must enter 'human' or 'computer'."
      puts
      puts "Is the codemaker a human or computer? (Enter 'human' or 'computer')"
      @codemaker_selection = gets.chomp.to_s.downcase
    end

    if @codemaker_selection == 'human'
      @codemaker = Human.new('Codemaker')
    elsif @codemaker_selection == 'computer'
      @codemaker = Computer.new("Codemaker")
    end

    # CODE BREAKER SELECTION
    @codebreaker_selection = ''
    puts "Is the codebreaker a human or computer? (Enter 'human' or 'computer')"
    @codebreaker_selection = gets.chomp.to_s.downcase
    until (@codebreaker_selection == 'human' || @codebreaker_selection == 'computer')
      puts "You must enter 'human' or 'computer'."
      puts
      puts "Is the codebreaker a human or computer? (Enter 'human' or 'computer')"
      @codebreaker_selection = gets.chomp.to_s.downcase
    end

    if @codebreaker_selection == 'human'
      @codebreaker = Human.new('Codebreaker')
    elsif @codebreaker_selection == 'computer'
      @codebreaker = Computer.new("Codebreaker")
    end  
  end

  def play_game()
    @code = @codemaker.select_code()
    game_start()
    puts "How many rounds do you want to play?"
    # NEED VALIDATION
    @rounds = gets.chomp.to_i

    @rounds.times do |round|
      puts "Round #{round+1}:"
      @guess = @codebreaker.guess_code()
      compare_guess(@guess, @code)
      display_guesses(@codebreaker.guess_array, @results)
      if @game_won == true
        return
      end
      if round+1 == @rounds
        @codemaker.win()
        @codebreaker.loss()
      end
    end

  end
end

mastermind = Game.new()
mastermind.create_players()
mastermind.play_game()

while true
  puts "Do you want to play again? (Y / N)"
  if gets.chomp.downcase == 'y'
    mastermind.play_game()
  else
    break
  end
end
