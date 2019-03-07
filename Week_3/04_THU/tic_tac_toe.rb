class Player

  attr_accessor :name, :sign

  def initialize(_sign, _player_id)
    puts "Quel est ton nom joueur #{_player_id} ?"
    @name = gets.chomp
    @sign = _sign # character that will be displayed when the player marks a space
  end

end

class BoardSpace

  attr_accessor :id # (1..9)
  attr_accessor :state # can be either its id or a player sign if it has been selected by a player

  def initialize(_id)
    @id = _id
    @state = _id
  end

end

class Board

  attr_accessor :board_spaces # stores the 9 spaces
  attr_accessor :winning_combinations # combinations of spaces that need to be filled by a player in order to win

  def initialize
    # fills the 9 spaces
    @board_spaces = []
    (1..9).each do |i|
      @board_spaces << BoardSpace.new(i)
    end

    # defines the wining combinations
    @winning_combinations = [
      [1, 2, 3], [4, 5, 6], [7, 8, 9],
      [1, 4, 7], [2, 5, 8], [3, 6, 9],
      [1, 5, 9], [3, 5, 7]
    ]
  end

  def display_board
    line_display = ""

    puts "-------------"

    @board_spaces.each do |board_space|
      case board_space.id % 3
      when 1..2
        line_display += "| #{board_space.state} "
      when 0
        line_display += "| #{board_space.state} |"
        puts line_display
        line_display = ""
        puts "-------------"
      end
    end
  end

end

class Game

  def initialize
    @turns = 0 # count turn number
    @cases_remaining = [1, 2, 3, 4, 5, 6, 7, 8, 9] # stores cases that can still be played
  end

  def launch_game
    # creates players
    @players = [Player.new("X", 1), Player.new("O", 2)]

    # creates board and display it
    @board = Board.new
    @board.display_board

    loop do
      play_turn
      if is_there_a_winner # if a player has won leave the game
        puts "#{@players[@turns%2].name} A GAGNE"
        break
      elsif @turns == 8 # after 9 turns, if no one has won leave the game (turns starts at 0, hence we check for 8)
        puts "EGALITE"
        break
      end
      @turns += 1
    end
  end

  # asks the player to play and updates the board
  def play_turn
    puts "#{@players[@turns%2].name} c'est a ton tour de jouer :"
    case_selected = ""
    loop do
      case_selected = gets.chomp.to_i
      # makes sure the input is one of the cases that haven't been played already
      if !@cases_remaining.include?(case_selected)
        puts "Mais non ! Entre un chiffre (entre 1 et 9, et qui n'a pas encore été joué) :"
      else
        @cases_remaining.delete(case_selected)
        break
      end
    end
    # fills the board with the player sign
    @board.board_spaces[case_selected - 1].state = @players[@turns%2].sign
    # displays the board
    @board.display_board
  end

  # returns true if there is a winner
  def is_there_a_winner
    return false if @turns < 4 # there can't be a winner before turn n°5 (turns starts at 0, hence we check for 4)

    # checks each winning combination
    @board.winning_combinations.each do |combination|
      checked_spaces = []
      combination.each do |i|
        # gets the value for this combination
        checked_spaces << @board.board_spaces[i-1].state
      end
      # returns true if the line tested does contain a unique character
      return true if checked_spaces.uniq.length == 1
    end

    return false
  end

end

my_game = Game.new
my_game.launch_game
